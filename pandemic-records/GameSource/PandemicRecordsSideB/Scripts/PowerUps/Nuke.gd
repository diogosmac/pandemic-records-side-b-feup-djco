extends 'res://Scripts/PowerUps/PowerUp.gd'

func executePowerUp(player):
	randomize()
	var randomVolume = rand_range(-2, 0)
	$nukeSound.set_volume_db(randomVolume)
	$nukeSound.play()
	player.nuke(true)
