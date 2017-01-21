extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var playerNumber = 0
export var speed = 10
export var jumpSpeed = 4
export var playerGravity = 9.81
var velocity = Vector3()
var keyPressCounter = 0

var key_up = ""
var key_down = ""
var key_left = ""
var key_right = ""
var key_jump = ""
var key_stomp = ""

var jumped = false

func _input(event):
	var snowmanAnimationPlayer = get_node("snowman_mesh/AnimationPlayer")
	if event.is_action_pressed(key_left) or event.is_action_pressed(key_right)  or event.is_action_pressed(key_up)  or event.is_action_pressed(key_down):
		keyPressCounter += 1
		snowmanAnimationPlayer.play("hop")
	if event.is_action_released(key_left) or event.is_action_released(key_right)  or event.is_action_released(key_up)  or event.is_action_released(key_down):
		keyPressCounter -= 1
	if keyPressCounter > 0:
		snowmanAnimationPlayer.get_animation("hop").set_loop(true)
	else:
		snowmanAnimationPlayer.get_animation("hop").set_loop(false)

func _fixed_process(delta):
	if (Input.is_action_pressed(key_left)):
		velocity.x = -speed
		set_rotation(Vector3(0,PI,0))
	elif (Input.is_action_pressed(key_right)):
		velocity.x = speed
		set_rotation(Vector3(0,2*PI,0))
	else:
		velocity.x = 0
	if (Input.is_action_pressed(key_up)):
		velocity.z = -speed
		set_rotation(Vector3(0,0.5*PI,0))
	elif (Input.is_action_pressed(key_down)):
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
		
		if self.get_translation().y < 0:
			var newPos = self.get_translation()
			newPos.y = 0
			self.set_translation(newPos)
		
		motion += Vector3(0, 0.1, 0)
		move(motion)
			
		if Input.is_action_pressed(key_stomp):
			var stompCenter = get_node("/root/Spatial/Wave").stomp(get_translation())
			set_translation(stompCenter)
		
		if Input.is_action_pressed(key_jump):
			jumped = true
			velocity.y = jumpSpeed
		else:
			jumped = false
			
	
	velocity += playerGravity * delta *Vector3(0, -1, 0)

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	#self.get_node("Beam").get_material_override().set_shader_param("BeamColor", Vector3(0, 1, 0))
	
	key_up = "ui_up" + str(playerNumber)
	key_down = "ui_down" + str(playerNumber)
	key_left = "ui_left" + str(playerNumber)
	key_right = "ui_right" + str(playerNumber)
	key_jump = "ui_jump" + str(playerNumber)
	key_stomp = "ui_stomp" + str(playerNumber)