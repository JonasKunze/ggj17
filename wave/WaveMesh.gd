extends Spatial

#export(FixedMaterial)    var material    = null
var myMesh = null
var gameTimePassed = 0
export var sizeX = 2
export var sizeZ = 2
var springConstant = 15
var friction = 0.01

var boxes = []
var velocities = []
var lastVertices = []

var mapscene = load("res://groundBox/groundBox.tscn")

export(Material) var material = null

func _ready():
	initBoxes()
	self.set_process(true)
	
func initBoxes():
	for z in range(0, sizeZ):
		var col = []
		var lastCol = []
		var velos = []
		boxes.append(col)
		lastVertices.append(lastCol)
		velocities.append(velos)
		
		for x in range(0, sizeX):
			var pos = Vector3(x-sizeX/2.0, 0, z-sizeZ/2.0)
			col.append(createBox(pos))
			lastCol.append(pos)
			velos.append(0)
			
	boxes[sizeZ/2.0][sizeX/2.0].set_translation(Vector3(0, 100, 0))
	lastVertices[sizeZ/2.0][sizeX/2.0] = boxes[sizeZ/2.0][sizeX/2.0].get_translation()

func createBox(position):
	var box = mapscene.instance()
	add_child(box)
	box.set_translation(Vector3(position))
	print(position)
	return box

func _process(deltaT):
	print(1/deltaT)
	gameTimePassed += deltaT
	
	var tsquareHalf = deltaT * deltaT / 2.0
	for z in range(1, sizeX-1):
		for x in range(1, sizeZ-1):
			var currentPos = boxes[z][x].get_translation()
			var force = 0
			for i in range(-1, 2):
				for j in range(-1, 2):
					if abs(i) + abs(j) == 2:
						force += 0.707* (lastVertices[z+i][x+j].y - currentPos.y)
					else:
						force += lastVertices[z+i][x+j].y - currentPos.y

			force *= springConstant * (1-friction)
			currentPos.y = tsquareHalf*force + velocities[z][x] * deltaT
			boxes[z][x].set_translation(currentPos)
			velocities[z][x] += force*deltaT
			lastVertices[z][x] = boxes[z][x].get_translation()
	