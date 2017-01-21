extends ImmediateGeometry

var gameTimePassed = 0
var matrix = []
var width = 50
var height = 50
var ct = 0

func _ready():
	for x in range(width):
		matrix.append([])
		for y in range(height):
			matrix[x].append(1)
	
	for i in range (width):
		for j in range (height):
			matrix[i][j]=sin(i/5.0)*sin(j/5.0)
	
	self.set_process(true)

func _process(deltaT):
	
	gameTimePassed += deltaT

	for i in range (width):
		for j in range (height):
			matrix[i][j]=sin(i+gameTimePassed/2.0)*sin(j+gameTimePassed/2.0)
	
	self.clear()
	
	self.begin(VS.PRIMITIVE_TRIANGLE_STRIP,null)
	for i in range (1,width-2):
		for j in range (height-1):
			self.set_color(Color(.5+.5*cos(gameTimePassed/5.0),.5+.5*sin(gameTimePassed/5.0),.5+.5*cos(gameTimePassed/5.0-1)))
			self.add_vertex(Vector3(i-width/2,j-height/2,matrix[i][j]))
			self.set_normal(Vector3(matrix[i+1][j]-2*matrix[i][j] - matrix[i+1][j], matrix[i][j+1]-matrix[i][j], -1))
			self.set_color(Color(.5+.5*cos(gameTimePassed/5.0),.5+.5*sin(gameTimePassed/5.0),.5+.5*cos(gameTimePassed/5.0-1)))
			self.add_vertex(Vector3(i+1-width/2,j-height/2,matrix[i][j]))
			self.set_normal(Vector3(matrix[i+1][j]-2*matrix[i][j] - matrix[i+1][j], matrix[i][j+1]-matrix[i][j], -1))
	self.end()
