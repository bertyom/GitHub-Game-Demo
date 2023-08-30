extends Node

export var quest_data = {}

func _ready():
	var quest_data_file = File.new()
	quest_data_file.open("res://Data/Quests.json", File.READ)
	var quest_data_json = JSON.parse(quest_data_file.get_as_text())
	quest_data_file.close()
	quest_data = quest_data_json.result

func _complete_linear_stage(quest_id): #use for quests that have a linear progression, each stage is completed in order
	var stages = quest_data[quest_id]["Stages"]
	var stage_id = null
	for i in range(stages.size()):
		if stages[str(i+1)]["Status"] == "Active":
			stage_id = i+1
			break
	if stage_id != null:
		_complete_stage(quest_id, stage_id)
	#if this the last stage, need to complete the quest too, otherwise activate the next stage
		if stage_id == stages.size():
			_complete_quest(quest_id)
		else:
			_activate_stage(quest_id, stage_id+1)

func _complete_stage(quest_id, stage_id):
	quest_data[quest_id]["Stages"][str(stage_id)]["Status"] = "Completed"

func _activate_stage(quest_id, stage_id):
	quest_data[quest_id]["Stages"][str(stage_id)]["Status"] = "Active"

func _complete_quest(quest_id):
	quest_data[quest_id]["Status"] = "Completed"

func _activate_quest(quest_id):
	quest_data[quest_id]["Status"] = "Active"

