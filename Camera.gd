extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player1 = null
var player2 = null
var lastCenter = Vector3(0,15,20)
func _ready():
	self.set_process(true)

func _process(deltaT):
	var player1 = get_node("/root/Spatial/Player1")
	var player2 = get_node("/root/Spatial/Player2")
	var center = (player1.get_translation()+player2.get_translation()) / 2.0
	var newCenter = 0.99*lastCenter + 0.01 * center
	set_translation(newCenter + Vector3(0,15,20))
	lastCenter = newCenter
	