extends MeshInstance

#export(FixedMaterial)    var material    = null
var myMesh = null
var gameTimePassed = 0
export var sizeX = 10
export var sizeZ = 10

func _ready():
	var surfTool = SurfaceTool.new()
	myMesh = Mesh.new()
	var material = FixedMaterial.new()
	material.set_parameter(material.PARAM_DIFFUSE,Color(1,0,0,1))
	  
	surfTool.set_material(material)
	surfTool.begin(VS.PRIMITIVE_TRIANGLES)

	for y in range(0, sizeZ):
		for x in range(0, sizeX):
			surfTool.add_vertex(Vector3(x,0,y))
			surfTool.add_vertex(Vector3(x+1,0,y))
			surfTool.add_vertex(Vector3(x+1,0,y+1))
			
			surfTool.add_vertex(Vector3(x,0,y))
			surfTool.add_vertex(Vector3(x+1,0,y+1))
			surfTool.add_vertex(Vector3(x,0,y+1))
	  
	surfTool.generate_normals()
	surfTool.index()
	  
	surfTool.commit(myMesh)
	  
	self.set_mesh(myMesh)
	
	self.set_process(true)
	
	pass

func _process(delta):
	gameTimePassed += delta
	var datatool = MeshDataTool.new()
	datatool.create_from_surface(myMesh, 0)
	datatool.set_vertex(0, datatool.get_vertex(0) )
	datatool.set_vertex(1, datatool.get_vertex(1) )
	#datatool.set_vertex(2, datatool.get_vertex(2) + Vector3(1,0,-1) * sin(gameTimePassed))
	print(datatool.get_vertex(2))
	
	myMesh.surface_remove(0) #Remove the old one
	datatool.commit_to_surface(myMesh)

	set_mesh(myMesh)
