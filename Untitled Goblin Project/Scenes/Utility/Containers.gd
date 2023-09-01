extends Node

var container_system_scene = preload("res://Scenes/GUI/ContainerSystem.tscn")
var existing_container_gui
var parent_prop

func _start():
	parent_prop = $"..".parent_node
	# Check if container GUI already exists
	existing_container_gui = CommonFunctions.UI_node.get_node_or_null("Container")
	if existing_container_gui: # If it exists, delete the instance
		_close()
		existing_container_gui.queue_free()
	else: #If not, create
		_open()
		
func _close():
	ActionSignaler.interaction_already_running = false
	if parent_prop.should_animate == true:
		parent_prop.get_node("AnimationPlayer").play("Close")
func _open():
	var container_system_instance = container_system_scene.instance()
	CommonFunctions.UI_node.add_child(container_system_instance)
	ActionSignaler.interaction_already_running = false
	if parent_prop.should_animate == true:
		parent_prop.get_node("AnimationPlayer").play("Open")
