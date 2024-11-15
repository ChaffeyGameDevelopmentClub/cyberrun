class_name IdlePlayerState

extends State

@export var player_speed = 6

#Why this no workey
#if Player.velocity.length() > 0.0  and Player.is_on_floor():
func update(delta):
	Global.player.update_gravity(delta)
	Global.player.update_input(player_speed)
	Global.player.update_velocity()

	if Global.player.velocity.length() > 0.0  and Global.player.is_on_floor():
		transition.emit("WalkingPlayerState")
