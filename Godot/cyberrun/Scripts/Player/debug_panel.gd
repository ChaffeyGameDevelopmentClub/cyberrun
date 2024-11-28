extends PanelContainer

#var property
@export var property_container : VBoxContainer
var FPS : String

func _ready() -> void:
	Global.debug = self
	visible = false
	#erm... i guess later
	#add_debug_property("FPS", FPS)

func _process(_delta):
	#if visible:
		#frames_per_second = "%.2f" % (1.0/delta)
	pass

#Makes it visible
func _input(event):
	if event.is_action_pressed("debug"):
		visible = !visible

#Automated adding stuff
func add_property(title: String, value, order):
	var target
	target = property_container.find_child(title,true,false)
	if !target: #First load
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible: #Updating
		target.text = title + ": " + str(value)
		property_container.move_child(target,order)
