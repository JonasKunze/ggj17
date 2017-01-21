extends Spatial

export var sizeX = 2
export var sizeZ = 2
var springConstant = 15
var friction = 0.01

var boxes = []
var waves = SphericalWaves.new()
var mapscene = load("res://groundBox/groundBox.tscn")

export(Material) var material = null

func _ready():
	waves.init(sizeZ, sizeX, springConstant, friction)
	for z in range(0, sizeZ):
		for x in range(0, sizeX):
			var pos = Vector3(x - sizeX/2.0, 0, z - sizeZ/2.0)
			var box = mapscene.instance()
			add_child(box)
			box.set_translation(Vector3(pos))
			boxes.append(box)
	boxes[sizeZ/2.0 * sizeX + sizeX/2.0].set_translation(Vector3(0, 0, 0))
	waves.setAmplitude(sizeZ/2.0, sizeX/2.0, 0)
	self.set_process(true)

func _process(deltaT):
	#print(1/deltaT)
	waves.update(deltaT)
	for z in range(1, sizeZ-1):
		for x in range(1, sizeX-1):
			var currentPos = boxes[z * sizeX + x].get_translation()
			currentPos.y = waves.getAmplitude(x, z)
			boxes[z * sizeX + x].set_translation(currentPos)
			
func stomp(position):
	var indexX = int(position.x)+sizeX/2
	var indexZ = int(position.z)+sizeZ/2
	waves.setAmplitude(indexX, indexZ, -100)