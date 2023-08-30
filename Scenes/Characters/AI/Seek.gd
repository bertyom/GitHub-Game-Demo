extends Node

var min_distance = 40
var max_distance = 60
var current_destination = null
var is_waiting = false
var seeking = true
var direction = Vector2.ZERO
var target = Vector2.ZERO
onready var wander_timer = $WanderTimer
onready var parent_node = $"../.."
onready var nav_agent = $"../../NavigationAgent2D"
var navigation_node
export(String, "Passive", "Agressive", "None") var behaviour_type

func start():  # Add a start method to be called when changing state
	_setup()
	seeking = true
	current_destination = navigation_node.get_closest_point(parent_node.lost_position)
	nav_agent.set_target_location(current_destination)

func _setup():
	navigation_node = CommonFunctions.navigation_node
	randomize()
	wander_timer.connect("timeout", self, "_on_wander_timer_timeout")

func _physics_process(delta):
	if seeking:
		if current_destination != null:
			target = parent_node.global_position.direction_to(current_destination)
			direction = target + parent_node.push_vector
			if (parent_node.global_position - current_destination).length() < 5:
				seeking = false
				is_waiting = true
				wander_timer.start(rand_range(0.5, 2.5))
			else:
				if target.x >= 0:
					parent_node.anim_tree.travel("R_Walk")
				else:
					parent_node.anim_tree.travel("L_Walk")
				parent_node.move_and_slide(direction * parent_node.movement_speed)
	elif !is_waiting:
		if current_destination != null and (parent_node.global_position - nav_agent.get_next_location()).length() < 5:
			is_waiting = true
			wander_timer.start(rand_range(0.5, 2.5))
		else:
			target = parent_node.global_position.direction_to(nav_agent.get_next_location())
			direction = target + parent_node.push_vector
			if target.x >= 0:
				parent_node.anim_tree.travel("R_Walk")
			else:
				parent_node.anim_tree.travel("L_Walk")
			parent_node.move_and_slide(direction * parent_node.movement_speed)
	else:
		if parent_node.facing_right:
			parent_node.anim_tree.travel("R_Idle")
		else:
			parent_node.anim_tree.travel("L_Idle")

func _on_wander_timer_timeout():
	is_waiting = false
	var random_distance = rand_range(min_distance, max_distance)
	var random_angle = rand_range(0, 2 * PI)
	current_destination = parent_node.global_position + Vector2(random_distance, 0).rotated(random_angle)
	current_destination = navigation_node.get_closest_point(current_destination)
	nav_agent.set_target_location(current_destination)
