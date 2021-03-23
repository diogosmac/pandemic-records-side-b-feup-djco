extends YSort

var obstacle
var obstacleScene
var obstacleSpawnLocation = position

var initialSpawnTimer
var spawnTimer

func _ready():
	if get_child_count() > 0:
		for i in get_children():
			i.queue_free()
	obstacleSpawnLocation = position

func _on_PlayButton_pressed():
	startGame()

func startGame():
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
