extends Node3D

var attack_damage := 10.0
var knockback_force := 100.0
var stun_time := 1.5


func _on_hitbox_component_area_entered(area: Area3D) -> void:
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
