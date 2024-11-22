class_name Player extends CharacterBody3D
#pause my menu idiot
@export var PauseMenu: Control
var paused = false

#dont tell them this but i stole everything from backwaters
#also dont tell them but im using this as my checklist hahahahahahahahaha
#TODO:
#Sliding, set distance at higher velocity, done from sprinting speed
#Wall Jump, detect if on wall when moving, apply velocity opposite of direction
#Dashing, kinda like a teleport, ask luna later lmao
#General UI
#oh wow theres a lot
#help me
#add in acceleration a bit, start at lower velocity, timer goes off and velocity ups
#going into idle resets timer

#SFX
#@export var Walk: AudioStreamPlayer
#@export var Run: AudioStreamPlayer
#Jumping :3
const jump_velocity = 4.5
var max_double_jump : int = 2
var double_jumps : int = 2
#Toggles for your actions, just so that its not a pain in the ass later
@export var canDJump = true
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
const headbob_move_amt = 0.06
const headbob_freq = 2.4
var headbob_time := 0.0
var newV

enum PLAYER_STATE{
	Idle,
	Air,
	Walking,
	Slide
}
@export var player_state = PLAYER_STATE.Idle

#pause menu or something idk
@export var pause : Control

func _ready() -> void:
	Global.player = self

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused==false:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x*sensitivity_camera)
			camera.rotate_x(-event.relative.y*sensitivity_camera)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(70))
	if get_tree().paused==true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pass

#Actually does the headbobbing, stolen btw
func _headbob_effect(delta):
	headbob_time += delta * self.velocity.length()
	camera.transform.origin = Vector3(
		cos(headbob_time * headbob_freq * 0.5) * headbob_move_amt,
		cos(headbob_time * headbob_freq) * headbob_move_amt,
		0
	)

func _physics_process(delta: float) -> void:
	#Debug Menu
	Global.debug.add_property("MovementSpeed",player_speed, 1)
	Global.debug.add_property("VelocityX",velocity.x,2)
	Global.debug.add_property("VelocityZ",velocity.z,3)
	Global.debug.add_property("VelocityY",velocity.y,4)
	Global.debug.add_property("CurrentState",player_state, 5)
	Global.debug.add_property("DoubleJumps",double_jumps, 6)
	
	_headbob_effect(delta)
	if is_on_floor():
		double_jumps = max_double_jump
	if not is_on_floor():
		player_state = 1
	match player_state: #Player states, this looks so dirty im kaying my essing self
		0: #Idle
			update_gravity(delta)
			update_input(player_speed)
			update_velocity()
			if velocity != Vector3(0,0,0):
				player_state = 2
		1: #In the air
			update_gravity(delta)
			update_input(player_speed)
			update_velocity()
			if is_on_floor():
				player_state = 0
		2: #Walking
			update_gravity(delta)
			update_input(player_speed)
			update_velocity()
			if velocity == Vector3(0,0,0):
				player_state = 0
			if Input.is_action_just_pressed("slide"):
				player_state = 3
				newV = velocity * 1.5
		3: #Sliding
			update_gravity(delta)
			update_velocity()
			velocity = lerp(velocity, newV, 0.2)
			if Input.is_action_just_released("slide"):
				player_state = 0
				newV = 0
#Functions that make the game work
func update_gravity(delta) -> void:
	velocity += get_gravity() * delta

#Movement
func update_input(player_speed: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * player_speed
		velocity.z = direction.z * player_speed
	else:
		velocity.x = move_toward(velocity.x, 0, player_speed)
		velocity.z = move_toward(velocity.z, 0, player_speed)

func update_velocity() -> void:
	move_and_slide()

#Could put inputs that can't be disabled like shooting, pause, stuff like that
func _input(event: InputEvent) -> void:
	# Jumping or something
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_just_pressed("jump") and not is_on_floor() and canDJump:
		if double_jumps <= 0:
			pass
		#if is_on_wall():
		
		#else:
			velocity.y = jump_velocity
			double_jumps -= 1
	#Do later
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()
		#Pause()

#Pause, completely pauses everything so you can go into options
func Pause():
	if get_tree().paused == false:
		pause.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		Engine.time_scale = 0
