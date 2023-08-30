extends Control

onready var parent_node = $".."
onready var bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	bar.value = parent_node.current_hp
	bar.max_value = parent_node.max_hp

func _on_get_damage():
	bar.value = parent_node.current_hp
