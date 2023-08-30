extends Control

onready var active_quests = $Margin/H/Tab/Active/Scroll/V
onready var completed_quests = $Margin/H/Tab/Completed/Scroll/V
onready var description_container = $Margin/H/Panel/Margin/Scroll


func _ready():
	_update_data()
	
func _update_data():
	_update_active()
	_update_completed()

func _update_active():
	for quest in Quests.quest_data:
		if Quests.quest_data[quest]["Status"] == "Active":
			if !active_quests.has_node(Quests.quest_data[quest]["ID"]):
				var quest_template = preload("res://Scenes/GUI/QuestTemplate.tscn").instance()
				quest_template.name = Quests.quest_data[quest]["ID"]
				quest_template.text = Quests.quest_data[quest]["Name"]
				active_quests.add_child(quest_template)

func _update_completed():
	for quest in Quests.quest_data:
		if Quests.quest_data[quest]["Status"] == "Completed":
			if !completed_quests.has_node(Quests.quest_data[quest]["ID"]):
				var quest_template = preload("res://Scenes/GUI/QuestTemplate.tscn").instance()
				quest_template.name = Quests.quest_data[quest]["ID"]
				quest_template.text = Quests.quest_data[quest]["Name"]
				completed_quests.add_child(quest_template)
			if active_quests.has_node(Quests.quest_data[quest]["ID"]): #delete it from active quests
				active_quests.get_node(Quests.quest_data[quest]["ID"]).queue_free()

func _on_button_pressed(id): #check if the description already has a node with the same name as id, if not, add it
	if description_container.has_node(str(id)):
		description_container.get_node(str(id))._update(id)
	else: #check if has any other children than h_scroll and v_scroll, if so, remove them
		if description_container.get_child_count() > 2:
			description_container.get_child(2).queue_free()
		#need to check the tab currently opened, and match the variable
		var quest_description_template = preload("res://Scenes/GUI/QuestDescriptionTemplate.tscn").instance()
		quest_description_template.name = id
		description_container.add_child(quest_description_template)
		var quest_description = description_container.get_node(str(id))
		quest_description._update(id) #need to connect quest_description.quest_giver somewhere to open character page in lorebook

func _on_Tab_tab_changed(tab):
	if description_container.get_child_count() > 2:
		description_container.get_child(2).queue_free()
