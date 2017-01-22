extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(Vector3) var startPosition = Vector3(0, 2, 0)

var goal1 = null
var goal2 = null
var points1 = 0
var points2 = 0

func _ready():
	goal1 = get_node("/root/Spatial/Goals/Goal1")
	goal2 = get_node("/root/Spatial/Goals/Goal2")
	self.set_process(true)

func _process(deltaT):
	var colliders = get_colliding_bodies()
	
	if colliders.size() == 1:
		if colliders[0] == goal1:
			set_translation(startPosition)
			points1 += 1
			get_parent().get_node("Control/player1Points").set_text("Points: " + str(points1))
		if colliders[0] == goal2:
			set_translation(startPosition)
			points2 += 1
			get_parent().get_node("Control/player2Points").set_text("Points: " + str(points2))
