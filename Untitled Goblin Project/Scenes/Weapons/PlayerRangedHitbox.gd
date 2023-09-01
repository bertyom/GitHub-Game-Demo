extends Area2D
var weapon_base_damage
var weapon_base_knockback
var location = null

func _ready():
	var item_id = PlayerData.equipment_data["WeaponRangedSlot"]
	weapon_base_damage = GameData.item_data[str(item_id)]["Attack"]
	weapon_base_knockback = GameData.item_data[str(item_id)]["Knockback"]
	location = $"..".global_position
