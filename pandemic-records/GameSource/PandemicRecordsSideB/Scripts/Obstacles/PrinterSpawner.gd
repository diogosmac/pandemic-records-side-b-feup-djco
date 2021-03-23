extends YSort

export(PackedScene) var obstacleScene

export(float) var FirstInterval = 7.9
export(float) var PrinterInterval = 7.2

var obstacle
var obstacleSpawnLocation = position

var initialSpawnTimer
var firstSpawnTimer
var secondSpawnTimer

func _ready():
	initialSpawnTimer = Global.oneShotTimer(
		FirstInterval, self, self, 'beginSpawning')
	firstSpawnTimer = Global.oneShotTimer(
		PrinterInterval, self, self, 'spawnFirst')
	secondSpawnTimer = Global.repeatingTimer(
		PrinterInterval * 2, self, self, 'spawnSecond')
	obstacleSpawnLocation = position

func _on_PlayButton_pressed():
	startGame()

func startGame():
	initialSpawnTimer.start()

func beginSpawning():
	initialSpawnTimer.queue_free()
	spawnObstacle()
	firstSpawnTimer.start()

func spawnFirst():
	spawnObstacle()
	secondSpawnTimer.start()

func spawnSecond():
	spawnObstacle()
	firstSpawnTimer.start()

func spawnObstacle():
	obstacle = obstacleScene.instance()
	obstacle.position = obstacleSpawnLocation
	obstacle.add_to_group('obstacles')
	get_parent().add_child(obstacle)

func _on_PlayerSpawner_you_died():
	firstSpawnTimer.queue_free()
	secondSpawnTimer.queue_free()
	self.queue_free()
