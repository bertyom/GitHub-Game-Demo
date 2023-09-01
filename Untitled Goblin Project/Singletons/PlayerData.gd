extends Node

var inv_data = {}
var player_node

var player_name = "Markus"

var player_base_stats = {
	"health": 100,
	"max_health": 100,
	"glint": 75,
	"max_glint": 100,
	"stamina": 50,
	"max_stamina": 50,
}

var player_exp = {
	"exp": 100,
	"next_lvl_exp": 300,
	"lvl": 1,
	"learning_points": 2
}

var player_abilities = {
	"Strength": 1,
	"Intelligence": 1,
	"Agility": 1,
	"Charisma": 1
}

var player_skill_tree = {
	"skill_1": {
		"cost": 10,
		"unlocked": true
	},
	"skill_2": {
		"cost": 20,
		"unlocked": false
	},
	"skill_3": {
		"cost": 30,
		"unlocked": false
	},
	"skill_4": {
		"cost": 40,
		"unlocked": false
	},
	"skill_5": {
		"cost": 50,
		"unlocked": false
	}
}

var equipment_data = {"PauldronLeftSlot": null,
	"HandLeftSlot": null,
	"RingLeftSlot": null,
	"BootLeftSlot": null,
	"HelmetSlot": null,
	"AmuletSlot": null,
	"ArmorSlot": null,
	"BeltSlot": null,
	"PantsSlot": null,
	"PauldronRightSlot": null,
	"HandRightSlot": null,
	"RingRightSlot": null,
	"BootRightSlot": null,
	"WeaponMeleeSlot": null,
	"WeaponRangedSlot": null}

func _ready():
	var inv_data_file = File.new()
	inv_data_file.open("res://Data/Inventory.json", File.READ)
	var inv_data_json = JSON.parse(inv_data_file.get_as_text())
	inv_data_file.close()
	inv_data = inv_data_json.result

func getPlayerStat(stat_name: String):
	return player_base_stats[stat_name]

func setPlayerStat(stat_name: String, value: int):
	player_base_stats[stat_name] = value
