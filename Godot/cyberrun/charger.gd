extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var navAgent: NavigationAgent3D
@export var cool_down: Timer
@export var stagger: Timer
@export var player : CharacterBody3D
var inAir : bool
var vulnerable : bool
var sight : bool
var charging : bool



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
			# See player 
			pass
		1: #wondering 
			#walk around while waiting 
			pass
		2:#attack
			#Charge at player 
			look_at(player.transform.origin)
			pass 
		3:#cooldown
			#start right after attack 
			#wait 5 second name timer wait
			# stagger when it a wall  
			if is_on_wall() and charging:
				charging = false
				stagger.start()
			pass
		4:#Air
			#Can't move 
			if is_on_floor():
				inAir = true
			#vulnerable/ double damage
				vulnerable = true
			else:
				inAir = false
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


func _on_cool_down_timeout() -> void:
	pass # Replace with function body.


func _on_sight_body_entered(body: Node3D) -> void:
	if body.name =="Player":
		entity_state = 2  
		# Replace with function body.


func _on_sight_body_exited(body: Node3D) -> void:
	if body.name =="Player": # Replace with function body.
		entity_state = 0
		

func _on_stagger_timeout() -> void:
	entity_state = 0 # Replace with function body.
