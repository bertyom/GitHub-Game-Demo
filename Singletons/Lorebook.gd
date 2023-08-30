extends Node

export var npc_data = {}
export var location_data = {}
export var enemy_data = {}
export var ingredient_data = {}

func _ready():
	var npc_data_file = File.new()
	npc_data_file.open("res://Data/Lorebook/NPCs.json", File.READ)
	var npc_data_json = JSON.parse(npc_data_file.get_as_text())
	npc_data_file.close()
	npc_data = npc_data_json.result

	var location_data_file = File.new()
	location_data_file.open("res://Data/Lorebook/Locations.json", File.READ)
	var location_data_json = JSON.parse(location_data_file.get_as_text())
	location_data_file.close()
	location_data = location_data_json.result

	var enemy_data_file = File.new()
	enemy_data_file.open("res://Data/Lorebook/Enemies.json", File.READ)
	var enemy_data_json = JSON.parse(enemy_data_file.get_as_text())
	enemy_data_file.close()
	enemy_data = enemy_data_json.result
	
	var ingredient_data_file = File.new()
	ingredient_data_file.open("res://Data/Lorebook/Ingredients.json", File.READ)
	var ingredient_data_json = JSON.parse(ingredient_data_file.get_as_text())
	ingredient_data_file.close()
	ingredient_data = ingredient_data_json.result

func _discover_npc(npc_id):
	npc_data[npc_id]["Discovered"] = true

func _change_affinity(npc_id, change):
	npc_data[npc_id]["Affinity"] += change
