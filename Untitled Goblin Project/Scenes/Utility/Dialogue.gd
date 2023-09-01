extends Node

export(Resource) var dialogue_file
export(String) var starting_node


func _start():
	DialogueManager.show_example_dialogue_balloon(starting_node, dialogue_file)
	get_tree().set_deferred("paused", true)
	
