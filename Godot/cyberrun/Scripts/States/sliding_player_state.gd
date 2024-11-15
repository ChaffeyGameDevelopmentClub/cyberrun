class_name SlidingPlayerState

extends State

#hella broken rn do later lmao
@export var player_speed: float = 8.0
@export var tilt_amt : float = 0.09
@export_range(1, 6, 0.1) var slide_anim_speed : float = 4.0

#@onready var crouch_shapecast 

func enter() -> void:
	pass

func update(delta):
	Global.player.update_gravity(delta)
	Global.player.update_velocity()
	
func finish():
	transition.emit("IdlePlayerState")
