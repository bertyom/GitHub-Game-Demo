extends Button

var lorebook

func _update_icon():
	if Lore.npc_data[self.name]["New"] == true:
		self.icon = load("res://Images/UI/QuestNewIcon.png")
	else:
		self.icon = null

func _ready():
	_update_icon()
	lorebook = $"../../../../../../.."
	if not self.is_connected("pressed", lorebook, "_on_button_pressed"):
		self.connect("pressed", lorebook, "_on_button_pressed", [self.name])

func _on_CharacterTemplate_pressed():
	if Lore.npc_data[self.name]["New"] == true:
		Lore.npc_data[self.name]["New"] = false
		_update_icon()
