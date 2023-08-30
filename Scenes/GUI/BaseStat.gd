extends Label

var text_to_set

func _ready():
	_update()
	
func _update():
	match self.name:
		"Level":
			text_to_set = str(PlayerData.player_exp["lvl"])
		"Learning Points":
			text_to_set = str(PlayerData.player_exp["learning_points"])
		"Health":
			text_to_set = str(PlayerData.player_base_stats["health"]) + "/" + str(PlayerData.player_base_stats["max_health"])
		"Glint":
			text_to_set = str(PlayerData.player_base_stats["glint"]) + "/" + str(PlayerData.player_base_stats["max_glint"])
		"Stamina":
			text_to_set = str(PlayerData.player_base_stats["stamina"]) + "/" + str(PlayerData.player_base_stats["max_stamina"])
	self.text = text_to_set
