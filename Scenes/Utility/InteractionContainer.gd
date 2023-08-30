extends Node

export(String, "Dialogue", "Switch", "Harvest", "Containers") var interaction_type
export(bool) var can_interact = true
var active_node
var for_ui_position
signal stop_outline
onready var parent_node = $".."

func _ready():
	active_node = get_node(interaction_type)
	connect("stop_outline", parent_node, "_Stop_outline")
	
func _on_PlayerInteracted():
	if can_interact == true:
		#could get spaghetti
		ActionSignaler.interaction_already_running = true
		active_node._start()

func _on_Harvest_harvestable():
	ActionSignaler.interaction_already_running = false
	can_interact = false
	emit_signal("stop_outline")
