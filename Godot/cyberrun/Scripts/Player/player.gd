extends CharacterBody3D
#pause my menu idiot
@export var PauseMenu: Control
var paused = false

#dont tell them this but i stole everything from backwaters
#also dont tell them but im using this as my checklist hahahahahahahahaha
#TODO:
#Sliding
#Wall Running
#Dashing
#Crosshair
#General UI
#oh wow theres a lot
#help me

#SFX
#@export var Walk: AudioStreamPlayer
#@export var Run: AudioStreamPlayer
#Jumping :3
const JUMP_VELOCITY = 4.5
var max_double_jump : int = 2
var double_jumps : int = 2
#Toggles for your actions, just so that its not a pain in the ass later
@export var canDJump = false
@export var canDash = true
@export var canSlide = true
#Speed and camera sensitivity vars
@export var sensitivity_camera = .001
@export var player_speed = 6
@export var head : Node3D
@export var camera : Camera3D
#gorl what does this mean
@export var isSound = false
#Headbob, it affects where you aim so like.... maybe not too much unless im goated and figure out how to seperate the two
const HEADBOB_MOVE_AMT = 0.06
const HEADBOB_FREQ = 2.4
var headbob_time := 0.0

#pause menu or something idk
@export var pause : Control

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	#What the fuck does any of this mean -Kev
	if get_tree().paused==false:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x*sensitivity_camera)
			camera.rotate_x(-event.relative.y*sensitivity_camera)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(70))

func _headbob_effect(delta):
	headbob_time += delta * self.velocity.length()
	camera.transform.origin = Vector3(
		cos(headbob_time * HEADBOB_FREQ * 0.5) * HEADBOB_MOVE_AMT,
		cos(headbob_time * HEADBOB_FREQ) * HEADBOB_MOVE_AMT,
		0
	)

	if get_tree().paused==true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#Resets your Double Jumps
	if is_on_floor():
		double_jumps = max_double_jump

	# Jumping or something
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#please tell me theres another way to write this PLEASE
	if Input.is_action_just_pressed("jump") and not is_on_floor() and canDJump:
		if double_jumps <= 0:
			pass
		else:
			velocity.y = JUMP_VELOCITY
			double_jumps -= 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * player_speed
		velocity.z = direction.z * player_speed
	else:
		velocity.x = move_toward(velocity.x, 0, player_speed)
		velocity.z = move_toward(velocity.z, 0, player_speed)
	_headbob_effect(delta)
	move_and_slide()

#inputs, i think?
func _input(event: InputEvent) -> void:
	#walking sound DELETE ASAP
	if velocity.x!=0 and velocity.z!=0 and isSound != true and is_on_floor():
		#Sound stuff, add in later
		#isSound = true
		#Walk.play()
		#await(Walk.finished)
		#isSound=false
		pass
	pass
	#these functions will handle pause for now but I THINK this is the neatest it can look rn
	if Input.is_action_just_pressed("pause"):
		Pause()
#Pause, completely pauses everything so you can go into options
func Pause():
	if get_tree().paused == false:
		pause.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		Engine.time_scale = 0
