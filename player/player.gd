extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const speed = 10
var velocity = Vector3()

func _fixed_process(delta):
	print(get_transform())
	if (Input.is_action_pressed("ui_left")):
		velocity.x = -speed
	elif (Input.is_action_pressed("ui_right")):
		velocity.x = speed
	else:
		velocity.x = 0
	if (Input.is_action_pressed("ui_up")):
		velocity.z = -speed
	elif (Input.is_action_pressed("ui_down")):
		velocity.z = speed
	else:
		velocity.z = 0
	
	var motion = velocity * delta
	motion = move(motion)

func _ready():
	set_fixed_process(true)