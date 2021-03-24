extends Area2D

var SpawnInterval = 5

export(float) var SpawnIntervalMin  	 = 1.00
export(float) var SpawnIntervalMax  	 = 3.00
export(int)   var IncreaseSpawnRateEvery = 10.0
export(float) var IncreaseSpawnsBy  	 = 1.10

export(float) var StandardProb = 60
export(float) var DormantProb  = 15
export(float) var BritishProb  = 25

var probs = {
	'standard': StandardProb,
	'dormant' : DormantProb,
	'british' : BritishProb
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

var randomAngle

var rng

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
	increaseSpawnRateTimer = Global.repeatingTimer(
		IncreaseSpawnRateEvery, self, self, 'onIncreaseSpawnRate')
	increaseSpawnRateTimer.stop()
	SpawnIntervalMin = 1.00
	SpawnIntervalMax = 3.00
	spawnEnemy()
	increaseSpawnRateTimer.start()

func spawnEnemy():
	spawnTimer = Global.oneShotTimer(SpawnInterval, self, self, 'onSpawnTimer')
	spawnTimer.start()
	
	# stop spawning while player not alive
	if Global.playerLimbo: return
	
	# skips a spawn if the spawner is obstructed
	for obj in get_tree().get_nodes_in_group('obstacles'):
		if overlaps_body(obj):
			return
	
	rng.randomize()
	var enemyType = rng.randi_range(1, totalProb)
	for key in probs:
		if enemyType <= probs[key]:
			spawnEnemyType(key)
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

func spawnEnemyType(type):
	enemySpawnLocation = position
	enemyScene = EnemyScenes[type]
	
	enemy = enemyScene.instance()
	enemy.variantType = type
	enemy.position = enemySpawnLocation
	enemy.add_to_group('enemies')
	
	rng.randomize()
	randomAngle = rng.randf_range(30, 150)
#	randomAngle = rng.randf_range(60, 120)
	
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
