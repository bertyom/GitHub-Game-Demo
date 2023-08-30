extends Control

onready var char_sheet = $TabContainer/Character/CharacterSheet
onready var quest_journal = $TabContainer/Journal/QuestJournal
onready var tabs = $TabContainer

func _on_tab_pressed(tab_index: int):
	if self.visible == false:
		self.visible = true
		tabs.current_tab = tab_index
		get_tree().set_deferred("paused", true)
	else:
		if tabs.current_tab != tab_index:
			tabs.current_tab = tab_index
		else:
			self.visible = false
			get_tree().set_deferred("paused", false)

func _process(delta):
	if Input.is_action_just_pressed("charsheet"):
		_on_tab_pressed(0)
	elif Input.is_action_just_pressed("journal"):
		_on_tab_pressed(1)
	elif Input.is_action_just_pressed("lorebook"):
		_on_tab_pressed(2)
	elif Input.is_action_just_pressed("map"):
		_on_tab_pressed(3)

func _on_ExitButton_pressed():
	self.visible = false
	get_tree().set_deferred("paused", false)

func _on_TabContainer_tab_selected(tab):
	match tab:
		0:
			char_sheet._update_data()
		1:
			quest_journal._update_data()
		2:
			pass
		3:
			pass
