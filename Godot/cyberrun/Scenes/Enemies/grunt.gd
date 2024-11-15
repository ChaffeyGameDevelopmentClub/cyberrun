extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var rethinkTimer : Timer = $Timers/Rethink

@export var navAgent : NavigationAgent3D

var inAir : bool
var canShoot : bool
var vulnerable : bool

enum ENTITY_STATE{
	Idle,
	Wander,
	RangedAttack,
	MeleeAttack,
	Air,
}
@export var entity_state = ENTITY_STATE.Idle

func _physics_process(delta: float) -> void:
	
	match entity_state:
		#For randomized attack paterns its going to be a random range based on the distance from the player
		#For example Melee no matter what in a small range of player while you have a chance to try melee at a range
		#idle
		0:pass
		1:#wander
			#Walks around
			pass
		2:#RangedAttack
			#Range charge shot and projectile shooter
			pass
		3:#MeleeAttack
			#Slicing within certain radius with specific arm, melee every 1.5 seconds
			pass
		4:#Air
			#Can't move nor shoot and is vulnerable
			if is_on_floor():
				inAir = true
				canShoot = false
				vulnerable = true
			pass
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.


	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
