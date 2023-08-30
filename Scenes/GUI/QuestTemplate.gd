extends Button

var quest_journal

func _update_icon():
	if Quests.quest_data[self.name]["New"] == true:
		self.icon = load("res://Images/UI/QuestNewIcon.png")
	else:
		self.icon = null

func _ready():
	_update_icon()
	quest_journal = $"../../../../../../.."
	if not self.is_connected("pressed", quest_journal, "_on_button_pressed"):
		self.connect("pressed", quest_journal, "_on_button_pressed", [self.name])
	
func _on_QuestTemplate_pressed():
	if Quests.quest_data[self.name]["New"] == true:
		Quests.quest_data[self.name]["New"] = false
		_update_icon()
