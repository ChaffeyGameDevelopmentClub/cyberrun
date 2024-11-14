extends PanelContainer

var property
@export var property_container : VBoxContainer
var FPS : String

func _ready() -> void:
	visible = false
	add_debug_property("FPS", FPS)

func _process(delta):
	if visible:
		#Based off of every frame, if this makes it incredibly laggy we'll use the actual built in function
		FPS = "%.2f" % (1.0/delta)
		property.text = property.name + ": " + FPS

#Makes it visible
func _input(event):
	if event.is_action_pressed("debug"):
		visible = !visible

#Adding stuff is easier
func add_debug_property(title : String,value):
	property = Label.new()
	property_container.add_child(property)
	property.name = title
	property.text = property.name + value
