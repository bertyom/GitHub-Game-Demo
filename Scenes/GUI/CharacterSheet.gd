extends Control

onready var stat_values = $"Margin/V/Top Bar/V/H/StatsValues"

func _ready():
	_update_data()

func _update_data(): #Check if each child is of Label type and has _update() function, call it
	for child in stat_values.get_children():
		if child is Label:
			if child.has_method("_update"):
				child._update()
