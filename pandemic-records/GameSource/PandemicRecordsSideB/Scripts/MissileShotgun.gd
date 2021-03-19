extends Area2D

export(int) var Speed = 800

export(int) var BlastRange = 200

var angle

var initPosition

func _ready():
	initPosition = position
	angle = Vector2( cos(rotation), sin(rotation) )

func _physics_process(delta):
	position += (angle * Speed) * delta
	if (position.distance_to(initPosition) > BlastRange):
		self.queue_free()

func _on_Missile_body_entered(enemy):
	enemy.missileHit(true)
