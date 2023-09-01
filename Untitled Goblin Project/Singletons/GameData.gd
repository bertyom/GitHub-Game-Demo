extends Node

var item_data = {}
var item_stats = ["Attack", "Knockback", "Defense", "HealthRestored", "EnergyRestored", "ManaRestored"]
var item_stats_labels = ["Attack", "Knockback", "Defense", "Health Restored", "Energy Restored", "Glint Restored"]
var equip_slot = {}
var weapon_lookup_data = {}
var enemy_weapon_stats = {}

func _ready():
	var enm_weapon_data_file = File.new()
	enm_weapon_data_file.open("res://Data/Enemy Weapons.json", File.READ)
	var enm_weapon_data_json = JSON.parse(enm_weapon_data_file.get_as_text())
	enm_weapon_data_file.close()
	enemy_weapon_stats = enm_weapon_data_json.result
	
	var item_data_file = File.new()
	item_data_file.open("res://Data/Item Database.json", File.READ)
	var item_data_json = JSON.parse(item_data_file.get_as_text())
	item_data_file.close()
	item_data = item_data_json.result

	for item_id in item_data:
		var item_info = item_data[item_id]
		var item_name = item_info["Name"]
		if item_info.has("Attack") and item_info["Attack"] != null:
			weapon_lookup_data[item_name] = item_id
