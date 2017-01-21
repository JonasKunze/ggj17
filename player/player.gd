extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var speed = 10
export var jumpSpeed = 4
var velocity = Vector3()
var keyPressCounter = 0

var jumped = false

func _input(event):
	var snowmanAnimationPlayer = get_node("snowman/AnimationPlayer")
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right")  or event.is_action_pressed("ui_up")  or event.is_action_pressed("ui_down"):
		keyPressCounter += 1
		snowmanAnimationPlayer.play("hop")
	if event.is_action_released("ui_left") or event.is_action_released("ui_right")  or event.is_action_released("ui_up")  or event.is_action_released("ui_down"):
		keyPressCounter -= 1
	if keyPressCounter > 0:
		snowmanAnimationPlayer.get_animation("hop").set_loop(true)
	else:
		snowmanAnimationPlayer.get_animation("hop").set_loop(false)

func _fixed_process(delta):
	if (Input.is_action_pressed("ui_left")):
		velocity.x = -speed
		set_rotation(Vector3(0,PI,0))
	elif (Input.is_action_pressed("ui_right")):
		velocity.x = speed
		set_rotation(Vector3(0,2*PI,0))
	else:
		velocity.x = 0
	if (Input.is_action_pressed("ui_up")):
		velocity.z = -speed
		set_rotation(Vector3(0,0.5*PI,0))
	elif (Input.is_action_pressed("ui_down")):
		velocity.z = speed
		set_rotation(Vector3(0,1.5*PI,0))
	else:
		velocity.z = 0
	
	var motion = velocity * delta
	motion = move(motion)
	
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		if n.y==0:
			motion += Vector3(0, 0.1, 0)
		move(motion)
		
		if jumped:
			var stompCenter = get_node("/root/Spatial/Wave").stomp(get_translation())
			set_translation(stompCenter)
		
		if Input.is_action_pressed("ui_jump"):
			jumped = true
			velocity.y = jumpSpeed
		else:
			jumped = false
			
	
	velocity += 9.81 * delta *Vector3(0, -1, 0)

func _ready():
	set_fixed_process(true)
	set_process_input(true)