extends Node
onready var parent_node = $"../.."
var stopped = false
var weapon
export(String, "Passive", "Agressive", "None") var behaviour_type

func _physics_process(delta):
	if not stopped:
		parent_node.move_and_slide(Vector2.ZERO)
		stopped = true
	if parent_node.facing_right:
		parent_node.anim_tree.travel("R_Death")
	else:
		parent_node.anim_tree.travel("L_Death")
