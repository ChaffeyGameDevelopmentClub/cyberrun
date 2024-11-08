extends CharacterBody3D
#pause my menu idiot
@export var PauseMenu: Control
var paused = false

#dont tell them this but i stole everything from backwaters

#SFX
#@export var Walk: AudioStreamPlayer
#@export var Run: AudioStreamPlayer
#Jumping
const JUMP_VELOCITY = 4.5
var max_double_jump : int = 3
var double_jumps : int = 3
#Speed and camera sensitivity vars
@export var sensitivity_camera = .001
@export var player_speed = 2.5
@export var neck : Node3D
@export var camera : Camera3D
#Stamina System, tweak later
@export var stamina = 100
@export var max_stamina = 200
@export var isSprint = false
@export var isTired = false
@export var isSound = false
#Camera effects color might not be used im sorry :(
@export var camera_color = 0

#pause menu or something idk
@export var pause : Control
#Animation vars including another fucking boolean because it will play over itself
@export var headBobbing : AnimationPlayer
var isAnimating = false

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	#clamps values, for some reason it works better here so lets call it magic
	stamina = clamp(stamina,0,max_stamina)

	if get_tree().paused==false:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x*sensitivity_camera)
			camera.rotate_x(-event.relative.y*sensitivity_camera)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(70))

	if get_tree().paused==true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pass

#literally the everything function
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
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if double_jumps <= 0:
			#haha no jumping for you
			pass
		else:
			velocity.y += JUMP_VELOCITY
			double_jumps -= 1
			print("fent left: ")
			print(double_jumps)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#Plays the head bobbing animation while a direction is being played, it should be easy to
		#edit within the animation tab so LOL
		#Do Later
		#if isSprint ==false:
			#if isAnimating == false:
				#isAnimating = true
				#headBobbing.play("player_walk_headbob")
				#await(headBobbing.animation_finished)
				#isAnimating =false
		#if isSprint == true:
			#if isAnimating == false:
				#isAnimating = true
				#headBobbing.play("player_run_headbob")
				#await(headBobbing.animation_finished)
				#isAnimating =false
		velocity.x = direction.x * player_speed
		velocity.z = direction.z * player_speed
	else:
		velocity.x = move_toward(velocity.x, 0, player_speed)
		velocity.z = move_toward(velocity.z, 0, player_speed)
	#Sprint
	if direction and isSprint==true and isTired!=true:
		stamina -= 2
	else:
		if stamina < 200:
			stamina +=1
	if stamina <10:
		isTired=true
	elif stamina>180:
		isTired=false
	move_and_slide()

#input testing but we need to get rid of test inputs in the final build
func _input(event: InputEvent) -> void:
	#Sprint
	if Input.is_action_pressed("sprint") and isTired==false:
		player_speed = 6
		isSprint=true
	elif isTired==true: 
		player_speed = 2.5
		isSprint=false
	if Input.is_action_just_released("sprint"):
		isSprint = false
		player_speed = 2.5
		pass
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
