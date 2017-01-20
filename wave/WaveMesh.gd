extends MeshInstance

#export(FixedMaterial)    var material    = null

func _ready():
  
  var surfTool = SurfaceTool.new()
  var mesh = Mesh.new()
  var material = FixedMaterial.new()
  material.set_parameter(material.PARAM_DIFFUSE,Color(1,0,0,1))
  
  surfTool.set_material(material)
  surfTool.begin(VS.PRIMITIVE_TRIANGLES)
  
  surfTool.add_uv(Vector2(0,0))
  surfTool.add_vertex(Vector3(-10,-10,0))
    
  surfTool.add_uv(Vector2(0.5,1))
  surfTool.add_vertex(Vector3(0,10,0))
  
  surfTool.add_uv(Vector2(1,0))
  surfTool.add_vertex(Vector3(10,-10,0))
  
  
  surfTool.generate_normals()
  surfTool.index()
  
  surfTool.commit(mesh)
  
  self.set_mesh(mesh)