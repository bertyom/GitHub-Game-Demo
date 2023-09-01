extends Panel


func _ready():
	_update()
	
func _update():
	get_node("Label").text = str(PlayerData.player_name)
