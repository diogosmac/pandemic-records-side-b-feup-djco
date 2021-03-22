extends YSort

var SpawnInterval = 5

export(float) var SpawnIntervalMin		 = 1.00
export(float) var SpawnIntervalMax		 = 3.00
export(int)   var IncreaseSpawnRateEvery = 10
export(float) var IncreaseSpawnsBy		 = 1.1

export(float) var StandardProb = 60
export(float) var DormantProb  = 15
export(float) var BritishProb  = 25

var probs = {
	'standard': StandardProb,
	'dormant':	DormantProb,
	'british':	BritishProb
}

var totalProb = StandardProb + DormantProb + BritishProb

var EnemyScenes = {
	'standard': 'res://Gameplay/Enemies/EnemyStandard.tscn',
	'dormant':  'res://Gameplay/Enemies/EnemyDormant.tscn',
	'british':  'res://Gameplay/Enemies/EnemyBritish.tscn'
}

var enemiesToSpawn

var enemy
var enemyScene
var enemySpawnLocation

var randomMin
var randomMax
var randomAngle

var rng

export(String, 'up', 'right', 'down', 'left', 'any') var Direction = 'down'

var spawnTimer
var increaseSpawnRateTimer


func _ready():
	rng = RandomNumberGenerator.new()
	for type in EnemyScenes:
		EnemyScenes[type] = load(EnemyScenes[type])

func _on_PlayButton_pressed():
	startGame()


func _on_PlayerSpawner_you_died():
	clearEnemies()
	Global.player = null

func createPowerUp(powerUpScene, location):
	if not get_tree().get_nodes_in_group('powerups'):
		var powerUp = powerUpScene.instance()
		powerUp.position = location
		call_deferred('spawnPowerUp', powerUp)

func spawnPowerUp(powerUp):
	powerUp.add_to_group('powerups')
	get_parent().add_child(powerUp)

func clearEnemies():
	if get_child_count() > 0:
		for i in get_children():
			i.queue_free()

func startGame():
	increaseSpawnRateTimer = Global.repeatingTimer(IncreaseSpawnRateEvery, self, self, 'onIncreaseSpawnRate')
	increaseSpawnRateTimer.stop()
	spawnEnemy()
	increaseSpawnRateTimer.start()

func spawnEnemy():
	spawnTimer = Global.oneShotTimer(SpawnInterval, self, self, 'onSpawnTimer')
	spawnTimer.start()

	rng.randomize()
	var enemyType = rng.randi_range(1, totalProb)
	for key in probs:
		if enemyType <= probs[key]:
			spawnEnemyType(key, Direction)
			break
		else:
			enemyType -= probs[key]

func getProb(keyword):
	# could really use a sum() function, but no such thing in GDScript :(
	var sum = 0
	for key in probs:
		if key != keyword: sum += probs[key]
		else: break
	return sum

func spawnEnemyType(type, direction):
	enemySpawnLocation = position
	enemyScene = EnemyScenes[type]

	match direction:
		'any':
			randomMin = 0
			randomMax = 360
		'up':
			randomMin = 180
			randomMax = 360
		'right':
			randomMin = 270
			randomMax = 450
		'down':
			randomMin = 0
			randomMax = 180
		'left':
			randomMin = 90
			randomMax = 270

	enemy = enemyScene.instance()
	enemy.variantType = type
	enemy.position = enemySpawnLocation
	enemy.add_to_group('enemies')

	rng.randomize()
	randomAngle = rng.randf_range(randomMin, randomMax)

	if randomAngle >= 90 && randomAngle <= 270:
		enemy.apply_scale(Vector2(-1,1))

	enemy.direction = Vector2( cos(randomAngle), sin(randomAngle) )
	enemy.spawnedBy = self

	get_parent().add_child(enemy)


func onSpawnTimer():
	spawnTimer.queue_free()
	rng.randomize()
	SpawnInterval = rng.randf_range(SpawnIntervalMin, SpawnIntervalMax)
	spawnEnemy()


func onIncreaseSpawnRate():
	SpawnIntervalMin /= IncreaseSpawnsBy
	SpawnIntervalMax /= IncreaseSpawnsBy
