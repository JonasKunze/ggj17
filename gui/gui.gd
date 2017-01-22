extends Control

var countdown = 60

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	

func _process(delta):
	countdown -= delta
	if countdown >= 0:
		get_node("time").set_text(str(round(countdown)))
	else:
		get_node("time").set_text("Time Over")
