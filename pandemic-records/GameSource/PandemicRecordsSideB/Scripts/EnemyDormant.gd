extends "res://Scripts/Enemy.gd"

var PowerUpScenes = {
	'quickfire': 'res://Gameplay/PowerUps/QuickFire.tscn',
	'nuke': 'res://Gameplay/PowerUps/Nuke.tscn'
}

export(int) var QuickFireProb = 0
export(int) var NukeProb = 25
# other powerup probs
export(int) var NoPowerUpProb = 0

var totalProb = QuickFireProb + NukeProb + NoPowerUpProb
var rng

func _ready():
	._ready()
	rng = RandomNumberGenerator.new()
	for key in PowerUpScenes:
		PowerUpScenes[key] = load(PowerUpScenes[key])

func onDeath():
	rng.randomize()
	var powerupType = rng.randi_range(1, totalProb)
	print('Power Up RNG:', powerupType)
	if powerupType <= QuickFireProb:
		spawnPowerUp('quickfire')
	elif powerupType <= QuickFireProb + NukeProb:
		spawnPowerUp('nuke')
	else:
		# no powerup
		pass

func spawnPowerUp(type):
	var powerUpScene = PowerUpScenes[type]
	var powerUp = powerUpScene.instance()
	powerUp.position = self.position
	powerUp.add_to_group('powerups')
	get_parent().add_child(powerUp)
