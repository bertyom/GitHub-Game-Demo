extends Node

onready var parent_node = $"../.."
onready var nav_agent = $"../../NavigationAgent2D"
var direction
var target
var target_location
var navigation_node
export(String, "Passive", "Agressive", "None") var behaviour_type

func start():
	_setup()
	
func _setup():
	navigation_node = CommonFunctions.navigation_node
	randomize()

func _physics_process(delta):
	# Update the target location every frame
	target_location = navigation_node.get_closest_point(PlayerData.player_node.global_position)
	nav_agent.set_target_location(target_location)
	
	# Calculate the direction towards the next waypoint
	target = parent_node.global_position.direction_to(nav_agent.get_next_location())
	direction = target + parent_node.push_vector
	# Move towards the waypoint
	if target.x >= 0:
		parent_node.anim_tree.travel("R_Walk")
	else:
		parent_node.anim_tree.travel("L_Walk")
	
	parent_node.move_and_slide(direction * parent_node.movement_speed)
