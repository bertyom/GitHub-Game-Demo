extends Control

onready var characters = $Margin/H/Tab/Characters/Scroll/V
onready var description_container = $Margin/H/Panel/Margin/Scroll
onready var tab = $Margin/H/Tab

func _ready():
	_update_data()
	
func _update_data():
	_update_characters()

func _update_characters():
	for character in Lore.npc_data:
		if Lore.npc_data[character]["Discovered"] == true:
			if !characters.has_node(Lore.npc_data[character]["Name"]):
				var character_template = preload("res://Scenes/GUI/CharacterTemplate.tscn").instance()
				character_template.name = Lore.npc_data[character]["Name"]
				character_template.text = Lore.npc_data[character]["Name"]
				characters.add_child(character_template)

func _on_button_pressed(name): #check if the description already has a node with the same name as name, if not, add it
	match tab.current_tab:
		0:
			if description_container.has_node(str(name)):
				description_container.get_node(str(name))._update(name)
			else: #check if has any other children than h_scroll and v_scroll, if so, remove them
				if description_container.get_child_count() > 2:
					description_container.get_child(2).queue_free()
				var quest_description_template = preload("res://Scenes/GUI/CharacterDescriptionTemplate.tscn").instance()
				quest_description_template.name = name
				description_container.add_child(quest_description_template)
				description_container.get_node(str(name))._update(name)

func _on_Tab_tab_changed(tab):
	if description_container.get_child_count() > 2:
		description_container.get_child(2).queue_free()
