extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var wait_timer = $wait_timer
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
			var randPos = setRandomPos()
			if navAgent.distance_to_target() <= 2:
				entity_state = 0
			else: 
				moveTo(randPos)
		2:#attack
			#Charge at player 
			look_at(player.transform.origin)
			moveTo(player.transform.origin)
			
		3:#cooldown
			#start right after attack 
			#wait 5 second name timer wait
			# stagger when it a wall  
			if is_on_wall() and charging:
				charging = false
				stagger.start()
		4:#Air
			#Can't move 
			if is_on_floor():
				inAir = true
			#vulnerable/ double damage
				vulnerable = true
			else:
				inAir = false
				vulnerable = false




	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	


	move_and_slide()
#function
func setTarget(target):
	navAgent.set_target_position(target)
func get_player_pos():
	var playerPos=player.transform.origin
	return playerPos
func moveTo(target): 
	navAgent.set_target_position(target)
	var next_nav_point=navAgent.get_next_path_position()
	var Newvelocity=(next_nav_point-global_transform.origin).normalized()* SPEED
	set_velocity(Newvelocity)
func setRandomPos():
		var pos= Vector3(randi_range(self.position.x-10,self.position.x+10),0,randi_range(self.position.z-10.,self.position.z+10))
		return pos
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
	