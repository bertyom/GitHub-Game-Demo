extends Node

signal close_tooltip

func _on_inventory_closed():
	emit_signal("close_tooltip")
