extends MeshInstance

#export(FixedMaterial)    var material    = null
var myMesh = null
var gameTimePassed = 0
export var sizeX = 2
export var sizeZ = 2
export var springConstant = 2

var vertices = []

export(Material) var material = null

func _ready():
	initVertices()
	createMesh()
	self.set_process(true)
	
func initVertices():
	for z in range(0, sizeZ):
		var col = []
		vertices.append(col)
		for x in range(0, sizeX):
			col.append(Vector3(x, 0, z))

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

func _process(delta):
	print(1/delta)
	gameTimePassed += delta
	for z in range(0, sizeX):
		for x in range(0, sizeZ):
			var vertexId = x*sizeZ + z
			vertices[z][x].y = sin(gameTimePassed*vertexId)
	createMesh()