extends 'res://Scripts/Enemies/Enemy.gd'

func _physics_process(delta):
	if Global.player:
		if Global.player.isAlive:
			direction = (Global.player.position - self.position)
			direction = direction.normalized()
	var enemy_wall_collision = move_and_collide(direction * Speed * delta)
	if enemy_wall_collision:
		direction.x = -direction.x
		enemy_wall_collision = move_and_collide(direction * Speed * delta)
