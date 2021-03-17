extends YSort

var SpawnInterval = 5

export(float) var SpawnIntervalMin = 1.00

export(float) var SpawnIntervalMax = 3.00

export(int) var increaseSpawnRateEvery = 10

export(float) var increaseSpawnsBy = 1.1

var EnemyScenes = [
	"res://Gameplay/Enemies/EnemyStandard.tscn",
	"res://Gameplay/Enemies/EnemyDormant.tscn",
	"res://Gameplay/Enemies/EnemyBritish.tscn"
]

var EnemyVariants = [
	"standard",
	"dormant",
	"british"
]

var enemiesToSpawn

var enemy
var enemyScene
var enemySpawnLocation

var randomMin
var randomMax
var randomAngle

var rng

export(String, "up", "right", "down", "left", "any") var Direction = "down"

var spawnTimer
var increaseSpawnRateTimer


func _ready():
	rng = RandomNumberGenerator.new()
	for i in range(0, EnemyScenes.size()):
		EnemyScenes[i] = load(EnemyScenes[i])


func _on_PlayButton_pressed():
	startGame()


func _on_PlayerSpawner_you_died():
	clearEnemies()
	Global.player = null


func clearEnemies():
	if get_child_count() > 0:
		for i in get_children():
			i.queue_free()


func startGame():
	increaseSpawnRateTimer = Global.repeatingTimer(increaseSpawnRateEvery, self, self, "onIncreaseSpawnRate")
	increaseSpawnRateTimer.stop()
	spawnEnemy()
	increaseSpawnRateTimer.start()


func spawnEnemy():
	spawnTimer = Global.oneShotTimer(SpawnInterval, self, self, "onSpawnTimer")
	spawnTimer.start()

	rng.randomize()
	var enemyType = rng.randi_range(0, EnemyScenes.size() - 1)
	spawnEnemyType(enemyType, Direction)


func spawnEnemyType(type, direction):
	enemySpawnLocation = position
	enemyScene = EnemyScenes[type]

	match direction:
		"any":
			randomMin = 0
			randomMax = 360
		"up":
			randomMin = 180
			randomMax = 360
		"right":
			randomMin = 270
			randomMax = 450
		"down":
			randomMin = 0
			randomMax = 180
		"left":
			randomMin = 90
			randomMax = 270

	enemy = enemyScene.instance()
	enemy.variantType = EnemyVariants[type]
	enemy.position = enemySpawnLocation
	enemy.add_to_group("enemies")

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
	SpawnIntervalMin /= increaseSpawnsBy
	SpawnIntervalMax /= increaseSpawnsBy
