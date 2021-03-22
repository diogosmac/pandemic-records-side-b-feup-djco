extends 'res://Scripts/Enemies/Enemy.gd'

var PowerUpScenes = {
	'quickfire': 'res://Gameplay/PowerUps/QuickFire.tscn',
	'nuke': 'res://Gameplay/PowerUps/Nuke.tscn'
}

export(int) var QuickFireProb = 25
export(int) var NukeProb = 25
# other powerup probs
export(int) var NoPowerUpProb = 25

var probs = {
	'quickfire':	QuickFireProb,
	'nuke': 		NukeProb,
	# other powerup probs,
	'none': 		NoPowerUpProb
}

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
	for key in probs:
		if key == 'none':
			return
		if powerupType <= probs[key]:
			spawnPowerUp(key)
			break
		else:
			powerupType -= probs[key]

func getProb(keyword):
	# could really use a sum() function, but no such thing in GDScript :(
	var sum = 0
	for key in probs:
		if key != keyword: sum += probs[key]
		else: break
	return sum

func spawnPowerUp(type):
	var powerUpScene = PowerUpScenes[type]
	spawnedBy.createPowerUp(powerUpScene, self.position)
