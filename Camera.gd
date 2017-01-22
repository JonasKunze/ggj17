extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player1 = null
var player2 = null
var lastCenter = Vector3(0,15,20)
var lastDistance = 100
func _ready():
	self.set_process(true)

func _process(deltaT):
	var player1 = get_node("/root/Spatial/Player1")
	var player2 = get_node("/root/Spatial/Player2")
	var center = (player1.get_translation()+player2.get_translation()) / 2.0
	var newCenter = 0.9*lastCenter + 0.1 * center
	var playerDistance = 0.9*lastDistance + 0.1 *(player1.get_translation()-player2.get_translation()).length()
	playerDistance = max(playerDistance, 20)
	lastDistance = playerDistance
	set_translation(newCenter + Vector3(0,15,20) * playerDistance / 28)
	lastCenter = newCenter
	
	var lookAt = newCenter - get_translation()
	var up = Vector3(1, 0, 0).cross(lookAt)
	look_at(newCenter, up)
	