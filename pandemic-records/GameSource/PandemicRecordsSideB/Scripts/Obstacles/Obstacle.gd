extends KinematicBody2D

export(float) var Speed = 150

var startPosition

var visibilityNotifier
var direction = Vector2(0, 1)

func _ready():
	startPosition = position
	visibilityNotifier = VisibilityNotifier2D.new()
	visibilityNotifier.set_rect(Rect2(-100, -100, 200, 200))
	add_child(visibilityNotifier)
	visibilityNotifier.connect('screen_exited', self, 'onScreenExit')

func _physics_process(delta):
	if Global.player:
		var collision = move_and_collide(direction * Speed * delta)
		if collision:
			if collision.collider.is_in_group('enemies'):
				collision.collider.missileHit(false, false)
	# collisions are buggy, and this is supposed to be an "immovable" object
	position.x = startPosition.x

func onScreenExit():
	self.queue_free()

func blowUp():
	randomize()
	var randomVolume = rand_range(-2, 0)
	$crashSound.set_volume_db(randomVolume)
	$crashSound.play()
	
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	
	$explosion.set_emitting(true)
	
	# wait a second for the sound to play then destroy self
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, 'timeout')
	
	self.queue_free()
