extends Node2D

var root

var score = 0

var hudScore
var hudLives

var player
var playerLimbo = true

func _ready():
	root = get_tree().get_root()

func oneShotTimer(time, called_from_node, add_as_child_of, callback):
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.connect('timeout', called_from_node, callback)
	timer.set_wait_time(time)
	# add as child of a specified node, e.g. a missile
	# that way if the parent node we're setting here is destroyed,
	# the timer will go with it, (e.g. when a missile times out)
	add_as_child_of.add_child(timer)
	
	return timer

func repeatingTimer(time, called_from_node, add_as_child_of, callback):
	var timer = Timer.new()
	timer.set_one_shot(false)
	timer.connect('timeout', called_from_node, callback)
	timer.set_wait_time(time)
	add_as_child_of.add_child(timer)
	
	return timer

func _process(_delta):
	if Input.is_action_pressed('exit'):
		get_tree().quit()

func incrementScore(amount):
	score += amount
	hudScore.set_text(str(score))
