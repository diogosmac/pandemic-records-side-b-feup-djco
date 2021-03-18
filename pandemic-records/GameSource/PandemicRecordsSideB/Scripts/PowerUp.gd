extends KinematicBody2D

export(float) var Speed = 150

var visibilityNotifier
var direction = Vector2(0, 1)

func _ready():
	print(position)
	visibilityNotifier = VisibilityNotifier2D.new()
	visibilityNotifier.set_rect(Rect2(-100, -100, 200, 200))
	add_child(visibilityNotifier)
	visibilityNotifier.connect("screen_exited", self, "onScreenExit")

func _physics_process(delta):
	var collision = move_and_collide(direction * Speed * delta)
	if collision:
		direction = direction.slide(collision.normal.normalized())

func caught():
	$CollisionPolygon2D.set_deferred("disabled", true)
	$character.set_visible(false)
	randomize()
	var randomVolume = rand_range(-2, 0)
	$pickupSound.set_volume_db(randomVolume)
	$pickupSound.play()
	executePowerUp()
	self.queue_free()

func executePowerUp():
	# "abstract" method to be overridden by subclasses
	pass

func onScreenExit():
	self.queue_free()
