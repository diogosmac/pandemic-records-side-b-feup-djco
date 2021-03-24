extends KinematicBody2D

export(int) var Speed = 400
export(PackedScene) var MissileScene
export(PackedScene) var ShotgunBlastScene
export(NodePath) var Barrel

export(float) var MissileInterval = 0.3
export(float) var ShotgunInterval = 1.0

export(float) var QuickFireDuration = 5.0
export(float) var QuickMissileInt = 0.15
export(float) var QuickShotgunInt = 0.5

export(int) var RespawnInterval = 1
var respawnTimer

var velocity

var missileTimer
var shotgunTimer

var slowMissileTimer
var slowShotgunTimer

var quickMissileTimer
var quickShotgunTimer
var quickFireTimer
var quickFireCooldown
var quickFireOnCooldown = false

var nukeCooldown
var nukeOnCooldown = false

var moveDirection
var fireFrom

var mousePosition
var aimPosition

var canFire = true
var isAlive = true

var playerSpawner

var canMove = false

var fireSound
var tookHitSound


func _ready():
	moveDirection = Vector2(0, 0)
	
	slowMissileTimer = Global.oneShotTimer(MissileInterval, self, self, 'onFiringTimerStopped')
	slowShotgunTimer = Global.oneShotTimer(ShotgunInterval, self, self, 'onFiringTimerStopped')
	quickMissileTimer = Global.oneShotTimer(QuickMissileInt, self, self, 'onFiringTimerStopped')
	quickShotgunTimer = Global.oneShotTimer(QuickShotgunInt, self, self, 'onFiringTimerStopped')
	
	missileTimer = slowMissileTimer
	shotgunTimer = slowShotgunTimer
	quickFireTimer = Global.oneShotTimer(QuickFireDuration, self, self, 'normalFire')
	
	respawnTimer = Global.oneShotTimer(RespawnInterval, self, self, 'respawnPlayer')
	
	fireFrom = $player_anim/waist/weapon/fireFrom
	
	$player_anim/Anim_Walk.play('walk')
	
	fireSound = $fireSound
	tookHitSound = $tookHitSound


func _physics_process(delta):
	# This code takes the angle the mouse is aiming at and converts it to a 
	# number that can represent a time in the player animation to jump to in
	# order to make the little dude look like he's pointing the rifle in the
	# right direction
	
	# 0 is aiming to the right
	# 90 is aiming straight down - 0.0
	# 180 is aiming to the left - 0.3 in animation
	# 270 is aiming straight up - 0.6
	
	var rotation_degrees = fposmod($aim.rotation_degrees, 360)
	
	var animation_time_range = 1.2
	var animation_split_into_degrees = animation_time_range / 360
	
	# mouse look
	mousePosition = get_global_mouse_position()
	$aim.look_at(mousePosition)
	
	aimPosition = to_global($aim.position)
	
	# Using separate left and right animations so can clip the whole player to face one direction or the other
	# If you flip within the animation you have to avoid tweening between facing right and left as though the
	# little dude were being spun in place.
	
	# aiming left
	if mousePosition.x < aimPosition.x:
		$player_anim/Anim_Aim.set_current_animation('aiming_left')
	# aiming right
	else:
		$player_anim/Anim_Aim.set_current_animation('aiming_right')
	
	var rotation_to_anim_time = (rotation_degrees - 0) * animation_split_into_degrees
	
	rotation_to_anim_time = clamp(rotation_to_anim_time, 0.0, animation_time_range)
	
	$player_anim/Anim_Aim.seek(rotation_to_anim_time)
	
	if canMove:
		# Move and collide
		if Input.is_action_pressed('left'):
			moveDirection.x = -1
		elif Input.is_action_pressed('right'):
			moveDirection.x = 1
		else:
			moveDirection.x = 0
		if Input.is_action_pressed('up'):
			moveDirection.y = -1
		elif Input.is_action_pressed('down'):
			moveDirection.y = 1
		else:
			moveDirection.y = 0
		
		# Fire left weapon
		if Input.is_action_pressed('left_fire'):
			leftFirePressed()
			
		# Fire right weapon
		elif Input.is_action_pressed('right_fire'):
			rightFirePressed()
		
		velocity = moveDirection * Speed
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.slide(collision.normal)
			var collider = collision.collider
			if collider.is_in_group('enemies'):
				var character = collider.get_node('character')
				if (character != null) and (character.is_visible()):
					hitByEnemy(collider)
			elif collider.is_in_group('powerups'):
				caughtPowerup(collider)
			elif collider.is_in_group('obstacles'):
				hitByObstacle(collider)
	
	if moveDirection.x == 0 && moveDirection.y == 0:
		$player_anim/Anim_Walk.play('rest')
	elif (not $player_anim/Anim_Walk.get_current_animation() == 'walk'):
		$player_anim/Anim_Walk.play('walk')


func leftFirePressed():
	firePressed(false)

func rightFirePressed():
	firePressed(true)

func firePressed(shotgun):
	if canFire:
		fireMissile(shotgun)
		var timer = shotgunTimer if shotgun else missileTimer
		# Start the firing timer
		timer.start()
		# Turn off the ability to fire until the firing interval time runs out
		canFire = false

func fireMissile(shotgun):
	# slight variation of volume so it doesn't get too rhythmic
	randomize()
	var randomVolume;
	if (shotgun):
		randomVolume = rand_range(0, 2)
	else:
		randomVolume = rand_range(-2, 0)
	
	fireSound.set_volume_db(randomVolume)
	fireSound.play()
	
	if (shotgun):
		shootShotgun()
	else:
		shootMissile()

func shootShotgun():
	# 70 degrees cone in aim direction
	for angle in [-35, -17.5, 0, 17.5, 35]:
		shoot(ShotgunBlastScene.instance(), deg2rad(angle))

func shootMissile():
	shoot(MissileScene.instance(), 0)

func shoot(bullet, angle):
	bullet.position = fireFrom.get_global_position()
	bullet.rotation = $aim.get_rotation() + angle
	bullet.add_to_group('missiles')
	get_tree().get_root().add_child(bullet)

func nuke(score):
	get_tree().call_group('enemies', 'missileHit', false, score)

func quickFire():
	missileTimer = quickMissileTimer
	shotgunTimer = quickShotgunTimer
	quickFireTimer.start()

func normalFire():
	missileTimer = slowMissileTimer
	shotgunTimer = slowShotgunTimer

func onFiringTimerStopped():
	# Set canFire back to true so the next round can be shot
	canFire = true

func hitByEnemy(enemy):
	tookHitSound.play()
	enemy.queue_free()
	literallyDie()

func hitByObstacle(obstacle):
	obstacle.blowUp()
	literallyDie()

func literallyDie():
	canMove = false
	
	$explosion.set_emitting(true)
	$player_anim.visible = false
	
	var playerCollision = get_node('CollisionShape2D')
	playerCollision.disabled = true
	playerSpawner.PlayerLives -= 1
	nuke(false)
	Global.hudLives.set_text(str(playerSpawner.PlayerLives))
	
	if playerSpawner.PlayerLives > 0:
		Global.playerLimbo = true
		respawnTimer.start()
	else:
		for missile in get_tree().get_nodes_in_group('missiles'):
			missile.queue_free()
		playerSpawner.playerDied()


func respawnPlayer():
	playerSpawner.spawnPlayer(true)
	canMove = true
	self.queue_free()

func caughtPowerup(powerUp):
	powerUp.caught(self)
