extends Control

export var countdown = 60
var ball
var snowmanAnimationPlayer = null
var finished = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	ball = get_node("/root/Spatial/Ball")

func _process(delta):
	countdown -= delta
	if countdown >= 0:
		get_node("time").set_text(str(round(countdown)))
	else:
		get_node("time").set_text("Time Over")
		var looser = null
		if ball.points1 > ball.points2:
			looser = get_node("/root/Spatial/Player1")
		elif ball.points1 < ball.points2:
			looser = get_node("/root/Spatial/Player2")
		
		if looser != null and !snowmanAnimationPlayer:
			snowmanAnimationPlayer = looser.get_node("snowman_mesh/AnimationPlayer")
			snowmanAnimationPlayer.play("die")
		finished = true