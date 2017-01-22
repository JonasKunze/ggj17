extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var spawnLikelihood = .001
export var bananaSpawnLikelihood = 0.005
export var maxEnemiesPerSpawn = 8

var player1=null
var player2=null

var width = -1
var height = -1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.set_process(true)
	randomize()
	player1 = get_node("/root/Spatial/Player1")
	player2 = get_node("/root/Spatial/Player2")
	width = get_node("/root/Spatial/Wave").sizeX
	height = get_node("/root/Spatial/Wave").sizeZ

#var positions = []
var enemies = []
var item = null
var itemHeight = 2.0
var itemRotation = 0.0

func getRandomSpawnPos(var maxDx = 0, var maxDy = 0):
	var result =  Vector3(randi()%(width-maxDx) - width/2 - 1, itemHeight, randi()%(height-maxDy) - height/2 - 1)
	return result

func _process(deltaT):
	if randf() < bananaSpawnLikelihood and item == null:
		item = load("res://items/bananas.scn").instance()
		item.set_scale(Vector3(.3,.3,.3))
		item.set_translation(getRandomSpawnPos())
		add_child(item)
	
	if item != null:
		itemRotation += deltaT * 1.2
		if itemRotation > 2*PI: itemRotation -= 2*PI
		itemHeight = 1+.7*sin(OS.get_ticks_msec() * .002)
		var tmpPos = item.get_translation()
		tmpPos.y = itemHeight
		item.set_translation(tmpPos)
		item.set_rotation(Vector3(0,itemRotation,0))
	
	if randf() < spawnLikelihood:
		var numberOfEnemies = randi()%maxEnemiesPerSpawn
		var spawnPos = getRandomSpawnPos(numberOfEnemies, numberOfEnemies)
		for i in range (0, numberOfEnemies):
			var enemy = load("res://enemy/stonyMonyText.scn").instance()
			var dirRand = randi()%3
			spawnPos += Vector3(1, 0, dirRand - 1)
			enemy.set_translation(spawnPos)
			enemy.set_rotation(Vector3(0,-PI*.5,0))
			enemies.append(enemy)
			add_child(enemy)
	
	var toBeDeleted = []
	for i in range(0, enemies.size()):
		var enemy = enemies[i]
		var pos = enemy.get_translation()
		if pos.y < 1:
			get_node("/root/Spatial/Wave").stomp(pos)
			get_node("/root/Spatial/Wave").putStone(pos)
			enemy.set_mode(1)
			toBeDeleted.append(i)
	
	for i in range(0, toBeDeleted.size()):
		enemies.remove(toBeDeleted[toBeDeleted.size()-i-1])
		
func destroyItem():
	if item != null:
		item.set_translation(Vector3(0, 5, 0))
		item.queue_free()
		item = null