extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var rethinkTimer : Timer = $Timers/Rethink
@onready var sight : Area3D = $Sight/CollisionSight
@export var player : CharacterBody3D
@export var navAgent : NavigationAgent3D
@export var sightradius : float

var see : bool
var inAir : bool
var canShoot : bool
var vulnerable : bool
var canMelee : bool

enum ENTITY_STATE{
	Idle,
	Wander,
	RangedAttack,
	MeleeAttack,
	Air,
}
@export var entity_state = ENTITY_STATE.Idle
func _ready() -> void:
	sight.radius = sightradius
func _physics_process(delta: float) -> void:
	var distance = ((pow(pow(self.position.x - player.position.x, 2) + (pow(self.position.z - player.position.z, 2)), 1/2 ))) 
	
	match entity_state:
		#For randomized attack paterns its going to be a random range based on the distance from the player
		#For example Melee no matter what in a small range of player while you have a chance to try melee at a range
		#idle
		0:#idle
			if see : 
				if canMelee : 
					entity_state = 3	
				elif (distance/sightradius) > randf_range(1/8, 1) :
					entity_state = 2
			else : entity_state = 1
				
		1:#wander
			#Walks around
			var randPos = setRandomPos()
			setTarget(randPos)
			if navAgent.distance_to_target() <= 2:
				entity_state = 0;
			else:
				moveTo()
		2:#RangedAttack
			#Range charge shot and projectile shooter
			pass
		3:#MeleeAttack
			
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


#Functions
func get_player_pos():
	var playerPos = player.transform.origin
	return playerPos
		
func setTarget(target):
	navAgent.set_target_position(target)
	
func moveTo():
	var next_nav_point = navAgent.get_next_path_position()
	var Newvelocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	set_velocity(Newvelocity)
	
	
func setRandomPos():
	var pos = Vector3(randi_range(self.position.x-10,self.position.x+10),0, randi_range(self.position.z-10, self.position.z+10))
	return pos


#singles
func _on_sight_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		see = true


func _on_sight_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		see = false
	
