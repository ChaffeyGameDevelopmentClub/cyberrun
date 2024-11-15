class_name PlayerMovementState

extends State

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player

func _process(delta: float) -> void:
	pass
