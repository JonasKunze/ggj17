extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var spawnLikelihood = .005
export var maxEnemiesPerSpawn = 8

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.set_process(true)
	randomize()

#var positions = []
var enemies = []

func _process(deltaT):
	if randf() < spawnLikelihood:
		var width = get_node("/root/Spatial/Wave").sizeX
		var height = get_node("/root/Spatial/Wave").sizeZ
		var spawnPos = Vector3(randi()%width - width/2, 3, randi()%height - height/2)
		for i in range (0, randi()%maxEnemiesPerSpawn):
			var enemy = load("res://enemy/stonyMonyText.scn").instance()
			var dirRand = randi()%3
			spawnPos += Vector3(1, 0, dirRand - 1)
			enemy.set_translation(spawnPos)
			enemies.append(enemy)
			add_child(enemy)
	
	var toBeDeleted = []
	for i in range(0, enemies.size()):
		var enemy = enemies[i]
		var pos = enemy.get_translation()
		if pos.y < 1: 
			get_node("/root/Spatial/Wave").stomp(pos)
			get_node("/root/Spatial/Wave").putStone(pos)
			toBeDeleted.append(i)
	
	for i in range(0, toBeDeleted.size()):
		enemies.remove(toBeDeleted[toBeDeleted.size()-i-1])