extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
#onready vars, Mostly timers
@onready var timer : Timer = $Timers/testingTimer
#export vars
@export var navAgent : NavigationAgent3D
@export var player : CharacterBody3D

#Status
var inAir : bool
var canShoot : bool
var vulnerable : bool
#States
var deployed : bool

enum ENTITY_STATE{
	Idle,
	Wander,
	Follow,
	Deploy,
	Air,
}
@export var entity_state = ENTITY_STATE.Idle

func _physics_process(delta: float) -> void:
	
	match entity_state:
		
		0:#idle
			#thinking phase, meant to decide which pase or just idle
			pass
		1:#Wander
			#wander within a range till fight starts
			pass
		2:#Follow
			#Follow team till num amount is met
			#how to follow buddies?
			pass
		3:#Deploy
			#idea is to deploy shield when around Num of enimies, and undeploy if num < amount needed
			pass
		
		4:#Air
			if not is_on_floor():
				#Can't move
				inAir = true
				#Can't Shoot
				canShoot = false
				#vurable/double damage
				vulnerable = true
			else:
				inAir = false
				canShoot = true
				vulnerable = false
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump. dunno if i can make this work, we will see.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, (SPEED/2))
		velocity.z = move_toward(velocity.z, 0, (SPEED/2))

	move_and_slide()

#Functions
func get_player_pos():
	var playerPos = player.transform.origin
	return playerPos
