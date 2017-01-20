extends ImmediateGeometry

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	print("hello world!")
	self.begin(VS.PRIMITIVE_TRIANGLES,null)
	self.add_vertex(Vector3(0,2,0))
	self.add_vertex(Vector3(2,0,0))
	self.add_vertex(Vector3(-2,0,0))
	self.end()
	pass
