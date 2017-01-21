extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var speed = 10
export var jumpSpeed = 4
var velocity = Vector3()

export var jumpTimeout_s = 2
var jumped = false
var lastJumpTime = 0

func _fixed_process(delta):
	#print(get_transform())
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
	
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
		
		if jumped:
			get_node("/root/Spatial/Wave").stomp(get_translation())
		
		if Input.is_action_pressed("ui_jump") && OS.get_unix_time()-lastJumpTime > jumpTimeout_s:
			jumped = true
			velocity.y = jumpSpeed
			lastJumpTime = OS.get_unix_time()
		else:
			jumped = false
			
	
	velocity += 9.81 * delta *Vector3(0, -1, 0)

func _ready():
	set_fixed_process(true)