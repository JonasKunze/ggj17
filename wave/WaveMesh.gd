extends MeshInstance

#export(FixedMaterial)    var material    = null
var myMesh = null
var gameTimePassed = 0
export var sizeX = 2
export var sizeZ = 2
var springConstant = 40
var friction = 0.05

var vertices = []
var velocities = []
var lastVertices = []

export(Material) var material = null

func _ready():
	initVertices()
	createMesh()
	self.set_process(true)
	
func initVertices():
	for z in range(0, sizeZ):
		var col = []
		var lastCol = []
		var velos = []
		vertices.append(col)
		lastVertices.append(lastCol)
		velocities.append(velos)
		
		for x in range(0, sizeX):
			col.append(Vector3(x, 0, z))
			lastCol.append(Vector3(x, 0, z))
			velos.append(0)
			
	vertices[50][50] = Vector3(0, 100, 0)
	lastVertices[50][50] = vertices[50][50]

func createMesh():
	var surfTool = SurfaceTool.new()
	myMesh = Mesh.new()
	#var material = FixedMaterial.new()
	#material.set_parameter(material.PARAM_DIFFUSE,Color(1,0,0,1))
	  
	surfTool.set_material(material)
	surfTool.begin(VS.PRIMITIVE_TRIANGLES)
	
	addVerticesToMesh(surfTool)

	surfTool.generate_normals()
	surfTool.index()
	  
	surfTool.commit(myMesh)
	  
	self.set_mesh(myMesh)
	
func addVerticesToMesh(surfTool):
	for z in range(0, sizeZ-1):
		for x in range(0, sizeX-1):
			surfTool.add_vertex(vertices[z][x])
			surfTool.add_vertex(vertices[z][x+1])
			surfTool.add_vertex(vertices[z+1][x+1])
			
			surfTool.add_vertex(vertices[z][x])
			surfTool.add_vertex(vertices[z+1][x+1])
			surfTool.add_vertex(vertices[z+1][x])

func _process(deltaT):
	print(1/deltaT)
	gameTimePassed += deltaT
	var tsquareHalf = deltaT * deltaT / 2.0
	for z in range(1, sizeX-1):
		for x in range(1, sizeZ-1):
			var currentY = vertices[z][x].y
			var north = lastVertices[z+1][x].y - currentY
			var east = lastVertices[z][x+1].y - currentY
			var south = lastVertices[z-1][x].y - currentY
			var west = lastVertices[z][x-1].y - currentY
			var force = springConstant * (north+east+south+west) - friction * velocities[z][x]
			
			vertices[z][x].y = tsquareHalf*force + velocities[z][x] * deltaT
			velocities[z][x] += force*deltaT
			
	lastVertices = vertices
	createMesh()