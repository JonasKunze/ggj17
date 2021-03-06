extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var playerNumber = 0
var speed = 10
var jumpSpeed = 4
var playerGravity = 9.81
var maxStepHeight = 0.5
var maxChargeTime = 1

var velocity = Vector3()
var keyPressCounter = 0
var bananaPartyStart = -100000
var bananaPartyMaxTime = 2000

var key_up = ""
var key_down = ""
var key_left = ""
var key_right = ""
var key_jump = ""
var key_stomp = ""

var jumped = false
var stompKeyPressedTime = 0
var wave = null

func _ready():
	wave = get_node("/root/Spatial/Wave")
	if playerNumber == 0:
		get_node("snowman_mesh/head/hat").set_hidden(true)
	else:
		get_node("snowman_mesh/head/scarf").set_hidden(true)
	#	get_node("hat").get_mesh().surface_get_material(0).set_parameter(0,Color(255,0,0))
	#else:
	#	get_node("hat").get_mesh().surface_get_material(0).set_parameter(0,Color(0,255,0))
		
		
	set_fixed_process(true)
	set_process_input(true)
	#self.get_node("Beam").get_material_override().set_shader_param("BeamColor", Vector3(0, 1, 0))
	
	key_up = "ui_up" + str(playerNumber)
	key_down = "ui_down" + str(playerNumber)
	key_left = "ui_left" + str(playerNumber)
	key_right = "ui_right" + str(playerNumber)
	key_jump = "ui_jump" + str(playerNumber)
	key_stomp = "ui_stomp" + str(playerNumber)

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
	if get_node("/root/Spatial/Control").finished: return
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
	
	didPlayerFallDown()
	
	if OS.get_ticks_msec() - bananaPartyStart < bananaPartyMaxTime:
		var stompCenter = get_node("/root/Spatial/Wave").stomp(get_translation(), 0.5)
		set_translation(stompCenter)
		
	if is_colliding():
		if get_parent().has_node("bananas") && get_collider() == get_parent().get_node("bananas"):
			bananaParty()
		
		var collisionNormal = get_collision_normal()
		motion = collisionNormal.slide(motion)
		#velocity = collisionNo.slide(velocity)
		move(motion)
		
		checkStompKey()

		if Input.is_action_pressed(key_jump) && collisionNormal.y != 0:
			jumped = true
			velocity.y = jumpSpeed
		else:
			jumped = false
		
		var myPos = self.get_translation()
		var heightColl = wave.getHeightAt(myPos)

		if myPos.y-heightColl < maxStepHeight:
			#print("pos:", get_node("/root/Spatial/Wave").getHeightAt(self.get_translation()))
			myPos.y = heightColl + 0.47 # insert translation y of snowman
			self.set_translation(myPos)
	
	velocity += playerGravity * delta *Vector3(0, -1, 0)

func checkStompKey():
	if Input.is_action_pressed(key_stomp) and stompKeyPressedTime == 0:
		stompKeyPressedTime = OS.get_ticks_msec()
	elif  not Input.is_action_pressed(key_stomp) and stompKeyPressedTime != 0:
		var amplitudeFactor = (OS.get_ticks_msec()-stompKeyPressedTime)/1000.0/maxChargeTime
		#print(amplitudeFactor, "!!!!!", (OS.get_ticks_msec()-stompKeyPressedTime))
		var stompCenter = wave.stomp(get_translation(), min(1, amplitudeFactor))
		set_translation(stompCenter)
		stompKeyPressedTime = 0
		
func bananaParty():
	get_node("/root/Spatial").destroyItem()
	bananaPartyStart = OS.get_ticks_msec()
		
func didPlayerFallDown():
	if self.get_translation().y < -10:
		get_node("/root/Spatial/SamplePlayer").play("wahwah")
		self.set_translation(Vector3(0, 10, 0))
		if playerNumber == 0:
			get_parent().get_node("Ball").points1 -= 1
			get_parent().get_node("Control/player1Points").set_text("Points: " + str(get_parent().get_node("Ball").points1))
		else:
			get_parent().get_node("Ball").points2 -= 1
			get_parent().get_node("Control/player2Points").set_text("Points: " + str(get_parent().get_node("Ball").points2))
		