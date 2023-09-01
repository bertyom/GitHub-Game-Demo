extends Node

var current_container_ID
export var container_loot = {}

func _ready():
	var inv_data_file = File.new()
	inv_data_file.open("res://Data/Containers.json", File.READ)
	var inv_data_json = JSON.parse(inv_data_file.get_as_text())
	inv_data_file.close()
	container_loot = inv_data_json.result
