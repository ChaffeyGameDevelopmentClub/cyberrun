class_name WalkingPlayerState

extends State

@export var player_speed = 6

func enter () -> void:
	Global.player.player_speed = Global.player.player_speed

func update(delta):
	Global.player.update_gravity(delta)
	Global.player.update_input(player_speed)
	Global.player.update_velocity()

	#if Input.is_action_just_pressed("slide") and Global.player.velocity.length() > 0.0:
		#Global.player.camera

	if Global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
