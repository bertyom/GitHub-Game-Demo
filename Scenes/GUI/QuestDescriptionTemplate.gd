extends VBoxContainer

onready var quest_name = $Name/Label
onready var quest_description = $Description
onready var quest_giver = $Giver/Name
onready var quest_steps = $Steps
var step_template

func _pull_icon(quest_id, stage): #just pulling icons
	match Quests.quest_data[quest_id]["Stages"][stage]["Status"]:
		"Active":
			quest_steps.get_node(stage).get_node("Icon").texture = load("res://Images/UI/QuestStepActive.png")
		"Completed":
			quest_steps.get_node(stage).get_node("Icon").texture = load("res://Images/UI/QuestStepCompleted.png")

func _pull_text(quest_id, stage): #if the stage is completed, make the description strikethrough and grey
	if Quests.quest_data[quest_id]["Stages"][stage]["Status"] == "Active":
		quest_steps.get_node(stage).get_node("Description").bbcode_text = Quests.quest_data[quest_id]["Stages"][stage]["StageDescription"]
	elif Quests.quest_data[quest_id]["Stages"][stage]["Status"] == "Completed":
		quest_steps.get_node(stage).get_node("Description").bbcode_text = "[s]" + Quests.quest_data[quest_id]["Stages"][stage]["StageDescription"] + "[/s]"
		quest_steps.get_node(stage).get_node("Description").add_color_override("default_color", DialogueVariables.hex_to_color("#7f7f7f"))

func _update(quest_id): #update information, using Quests.quest_data singleton
	quest_name.text = Quests.quest_data[quest_id]["Name"]
	quest_description.bbcode_text = Quests.quest_data[quest_id]["Description"]
	quest_giver.text = Quests.quest_data[quest_id]["Questgiver"]
	for stage in Quests.quest_data[quest_id]["Stages"]: #if stage doesn't exist in UI, add it. Otherwise, update it
		if !quest_steps.has_node(stage):
			if Quests.quest_data[quest_id]["Stages"][stage]["Status"] != "Inactive":
				step_template = load("res://Scenes/GUI/QuestStepTemplate.tscn").instance()
				step_template.name = stage
				quest_steps.add_child(step_template)
				_pull_text(quest_id, stage)
				_pull_icon(quest_id, stage)
		else: #Need to update that step
			_pull_text(quest_id, stage)
			_pull_icon(quest_id, stage)
