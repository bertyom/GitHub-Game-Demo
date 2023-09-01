extends Node

export(String) var item_ID
export var quantity = 1
export(bool) var harvestable = true
var slot_name
var slot_data
var max_stack
var item_already_added = false
signal harvestable


func _start():
	var parent_prop = $"..".parent_node
	if item_already_added == false:
		CommonFunctions._add_item(item_ID, quantity)
		emit_signal("harvestable")
		item_already_added = true
	if parent_prop.should_animate == true:
		parent_prop.get_node("AnimationPlayer").play("Harvest")
