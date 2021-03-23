extends KinematicBody2D

export(String, 'standard', 'british', 'dormant') var variantType = 'standard'
var variantIndexes = {
	'standard': 0,
	'british': 1,
	'dormant': 2,
}
var variantSpeeds = [200, 200, 150]
var variantScores = [ 25,  50,  10]

var spawnedBy
var direction

var Variant
var Speed
var Score

var visibilityNotifier


func _ready():
	visibilityNotifier = VisibilityNotifier2D.new()
	visibilityNotifier.set_rect(Rect2(-100, -100, 200, 200))
	add_child(visibilityNotifier)
	visibilityNotifier.connect('screen_exited', self, 'onScreenExit')
	Variant = variantIndexes[variantType]
	Speed = variantSpeeds[Variant]
	Score = variantScores[Variant]
	if direction.y * Speed < 300:
		direction.y = 300 / Speed
		direction = direction.normalized()

func _physics_process(delta):
	var collision = move_and_collide(direction * Speed * delta)
	if collision:
		if collision.collider.is_in_group('obstacles'):
			missileHit(false, false)
		direction.x = -direction.x
		collision = move_and_collide(direction * Speed * delta)


func missileHit(bullet, score):
	# only trigger on death effects if killed by bullet
	if bullet:
		# slightly vary the volume of the sound played when missile hits enemy
		randomize()
		var randomVolume = rand_range(-2, 0)
		$hitSound.set_volume_db(randomVolume)
		$hitSound.play()
		
		onDeath()
	
	$CollisionPolygon2D.set_deferred('disabled', true)
	$character.set_visible(false)
	
	$explosion.set_emitting(true)
	
	if score:
		Global.incrementScore(Score)
	
	# wait a second for the sound to play then destroy self
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, 'timeout')

	self.queue_free()

func onDeath():
	# 'abstract' to be implemented by types of enemies in which it makes sense
	pass

func onScreenExit():
	self.queue_free()
