extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var navAgent: NavigationAgent3D
var inAir : bool
var vulnerable : bool

enum ENTITY_STATE{
	Idle, 
	wondering,
	attack,
	cooldown, 
	Air,  	
}
@export var entity_state = ENTITY_STATE.Idle

func _physics_process(delta: float) -> void:
	match entity_state:
		#Idle 
		0:#Idle
			#wait in places 
			#look around 
			pass
		1: #wondering 
			#walk around while waiting 
			pass
		2:#attack
			#See player 
			#Charge at player 
			pass 
		3:#cooldown
			#start right after attack 
			#wait 5 second name timer wait
			# stagger when it a wall  
			#name timer stagger
			pass
		4:#Air
			#Can't move 
			if is_on_floor():
				inAir = true
			#vulnerable/ double damage
				vulnerable = false

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
