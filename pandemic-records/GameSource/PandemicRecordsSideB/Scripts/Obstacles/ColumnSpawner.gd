extends YSort

export(PackedScene) var obstacleScene

export(float) var FirstColumn = 10
export(float) var ColumnInterval = 7.5

var obstacle
var obstacleSpawnLocation = position

var initialSpawnTimer
var spawnTimer

func _ready():
	initialSpawnTimer = Global.oneShotTimer(
		FirstColumn, self, self, 'beginSpawning')
	spawnTimer = Global.repeatingTimer(
		ColumnInterval, self, self, 'spawnObstacle')
	obstacleSpawnLocation = position

func _on_PlayButton_pressed():
	startGame()

func startGame():
	print('Starting timer')
	initialSpawnTimer.start()

func beginSpawning():
	print('Starting spawns')
	initialSpawnTimer.queue_free()
	spawnObstacle()
	spawnTimer.start()

func spawnObstacle():
	obstacle = obstacleScene.instance()
	obstacle.position = obstacleSpawnLocation
	obstacle.add_to_group('obstacles')
	get_parent().add_child(obstacle)

func _on_PlayerSpawner_you_died():
	spawnTimer.stop()
	self.queue_free()
