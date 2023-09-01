extends Area2D
onready var parent_weapon = $"../.."
var weapon_base_damage
var weapon_base_knockback
var location = null

func _ready():
	var item_id = GameData.weapon_lookup_data[parent_weapon.name]
	weapon_base_damage = GameData.item_data[item_id]["Attack"]
	weapon_base_knockback = GameData.item_data[item_id]["Knockback"]
