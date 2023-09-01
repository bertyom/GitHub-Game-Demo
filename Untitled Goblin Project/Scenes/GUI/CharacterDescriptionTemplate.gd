extends VBoxContainer

onready var character_name = $Name/Label
onready var character_description = $Info/Description
onready var character_portrait = $Info/V/Portrait
onready var affinity_bar = $Info/V/H/ProgressBar
onready var affinity_number = $Info/V/H/ProgressBar/Label
onready var affinity_type = $Info/V/H/AffinityType

func _update(character_id): #update information, using Quests.quest_data singleton
	character_name.text = Lore.npc_data[character_id]["Name"]
	character_description.bbcode_text = Lore.npc_data[character_id]["Description"]
	character_portrait.texture = load("res://Images/CharacterPortraits/"+Lore.npc_data[character_id]["ImageFile"]+".png")
	match Lore.npc_data[character_id]["AffinityType"]:
		"Friendship":
			affinity_type.texture = load("res://Images/UI/IconAffinityFriend.png")
		"Love":
			affinity_type.texture = load("res://Images/UI/IconAffinityLove.png")
	affinity_number.text = str(Lore.npc_data[character_id]["Affinity"])+"/100"
	affinity_bar.value = Lore.npc_data[character_id]["Affinity"]
