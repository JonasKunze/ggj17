extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var spawnLikelihood = .005

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.set_process(true)
	randomize()

#var positions = []
var enemies = []

func _process(deltaT):
	if randf() < spawnLikelihood:
		var enemy = load("res://enemy/stonyMonyText.scn").instance()
		
		var width = get_node("/root/Spatial/Wave").sizeX
		var height = get_node("/root/Spatial/Wave").sizeZ
		var tmp = Vector3(randi()%width - width/2, 30, randi()%height - height/2)
		#positions.append((randi()%width - width/2, randi()%height - height/2, 50))
		enemy.set_translation(tmp)
		#enemy.velocity.y = 
		enemies.append(enemy)
		add_child(enemy)
	
	for enemy in enemies:
		var pos = enemy.get_translation()
		if pos.y > 1: 
			pos.y += deltaT * enemy.velocity.y
			if pos.y < 1: 
				pos.y = 0
				enemy.velocity.y = 0
				get_node("/root/Spatial/Wave").stomp(pos)
			else:
				#print (enemy.velocity.y)
				enemy.velocity.y -= deltaT * 10
		
		if enemy.velocity.y == 0:
			get_node("/root/Spatial/Wave").waves.setAmplitude(pos.x, 0, pos.z)
		enemy.set_translation(pos)