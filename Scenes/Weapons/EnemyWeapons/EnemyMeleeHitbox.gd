extends Area2D
onready var parent_weapon = $".."
export(int) var weapon_base_damage
export(int) var weapon_base_knockback
var hit_position

func _ready():
	weapon_base_damage = GameData.enemy_weapon_stats[str(parent_weapon.name)]["Attack"]
	weapon_base_knockback = GameData.enemy_weapon_stats[str(parent_weapon.name)]["Knockback"]
	
func _process(delta):
	hit_position = parent_weapon.global_position
