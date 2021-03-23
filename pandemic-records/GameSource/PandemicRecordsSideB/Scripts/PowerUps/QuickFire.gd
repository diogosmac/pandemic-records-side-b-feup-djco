extends 'res://Scripts/PowerUps/PowerUp.gd'

func executePowerUp(player):
	randomize()
	var randomVolume = rand_range(-2, 0)
	$quickFireSound.set_volume_db(randomVolume)
	$quickFireSound.play()
	player.quickFire()
