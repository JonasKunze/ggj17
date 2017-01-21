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
	waves.setAmplitude(sizeZ/2.0, sizeX/2.0, -100)
	waves.applyAmplitude(boxes, 1)
	
	self.set_process(true)

func _process(deltaT):
	print(1/deltaT)
	waves.update(deltaT)
	waves.applyAmplitude(boxes, 1)