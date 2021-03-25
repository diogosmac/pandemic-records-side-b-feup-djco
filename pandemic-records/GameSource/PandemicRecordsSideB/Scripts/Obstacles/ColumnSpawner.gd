extends YSort

export(PackedScene) var obstacleScene

export(float) var FirstColumn = 5
export(float) var ColumnInterval = 12

var obstacle
var obstacleSpawnLocation = position

var initialSpawnTimer
var spawnTimer

func _ready():
	obstacleSpawnLocation = position

func _on_PlayButton_pressed():
	startGame()

func startGame():
	initialSpawnTimer = Global.oneShotTimer(
		FirstColumn, self, self, 'beginSpawning')
	spawnTimer = Global.repeatingTimer(
		ColumnInterval, self, self, 'spawnObstacle')
	initialSpawnTimer.start()

func beginSpawning():
	initialSpawnTimer.queue_free()
	spawnObstacle()
	spawnTimer.start()

func spawnObstacle():
	obstacle = obstacleScene.instance()
	obstacle.position = obstacleSpawnLocation
	obstacle.add_to_group('obstacles')
	get_parent().add_child(obstacle)

func _on_PlayerSpawner_you_died():
	spawnTimer.queue_free()
