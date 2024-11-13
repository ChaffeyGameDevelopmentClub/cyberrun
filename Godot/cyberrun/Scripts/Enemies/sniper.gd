extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var ani_play: AnimationPlayer
@export var player: CharacterBody3D
@export var cool_down_time: Timer 
@export var charging_time: Timer
@export var gun: Node3D
@export var ray: RayCast3D
var charging: bool
var cool_down:bool
func _physics_process(delta: float) -> void:
	# Add the gravity.


#add recoior 
#aim for the player 

	if not charging: 
		gun.look_at(player.global_transform.origin)
#fire
	if ray.get_collider() == player: 
		charging= true
		charging_time.start()





	move_and_slide()


func _on_charging_time_timeout() -> void:
	charging= false# Replace with function body.
		#damaged  
	#cool down
	cool_down_time.start()


func _on_gun_cooldown_timeout() -> void:
	cool_down= false # Replace with function body.
