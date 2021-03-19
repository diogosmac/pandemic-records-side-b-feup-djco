extends 'res://Scripts/Enemies/Enemy.gd'

var PowerUpScenes = {
	'quickfire': 'res://Gameplay/PowerUps/QuickFire.tscn',
	'nuke': 'res://Gameplay/PowerUps/Nuke.tscn'
}

export(int) var QuickFireProb = 25
export(int) var NukeProb = 25
# other powerup probs
export(int) var NoPowerUpProb = 25

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
	if powerupType <= QuickFireProb:
		spawnPowerUp('quickfire')
	elif powerupType <= QuickFireProb + NukeProb:
		spawnPowerUp('nuke')
	else:
		# no powerup
		pass

func spawnPowerUp(type):
	var powerUpScene = PowerUpScenes[type]
	spawnedBy.createPowerUp(powerUpScene, self.position)
