extends "res://Scripts/PowerUp.gd"

func executePowerUp():
	get_tree().call_group("enemies", "missileHit")
