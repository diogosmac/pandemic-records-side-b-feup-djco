extends Node2D

signal you_died

export(PackedScene) var PlayerScene
export(int) var InvincibleTime = 3
export(int) var PlayerStartingLives = 3
var PlayerLives = 3

var player

var invincibleTimer

var playerCollision
var playerSprite
var playerWeapon

func _on_Play_Button_pressed():
	PlayerLives = PlayerStartingLives
	for obstacle in get_tree().get_nodes_in_group('obstacles'):
		obstacle.queue_free()
	startGame()

func startGame():
	spawnPlayer(false)
	Global.hudLives.set_text(str(PlayerLives))

func spawnPlayer(isRespawn):
	player = PlayerScene.instance()
	player.position = Vector2(950, 950)
	Global.player = player
	player.playerSpawner = self
	
	add_child(player)
	
	if isRespawn:
		invincibleTimer = Global.oneShotTimer(InvincibleTime, self, player, 'onInvincibleTimerStopped')
		
		player.set_collision_layer_bit(1, false)
		player.set_collision_layer_bit(2, false)
		
		playerSprite = player.get_node('player_anim')
		playerSprite.set_modulate(Color(1, 1, 1, 0.25))
		
		invincibleTimer.start()
		
		player.canMove = true
		player.canFire = false
		player.isAlive = false
	else:
		player.canMove = true


func playerDied():
	player.queue_free()
	emit_signal('you_died')

func onInvincibleTimerStopped():
	player.set_collision_layer_bit(1, true)
	player.set_collision_layer_bit(2, true)
	player.canFire = true
	player.isAlive = true
	playerSprite.set_modulate(Color(1, 1, 1, 1))
