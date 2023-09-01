extends Node

var min_distance = 30
var max_distance = 50
var current_destination = null
var is_waiting = false
var direction = Vector2.ZERO
var target = Vector2.ZERO
onready var wander_timer = $WanderTimer
onready var parent_node = $"../.."
onready var nav_agent = $"../../NavigationAgent2D"
var navigation_node
export(String, "Passive", "Agressive", "None") var behaviour_type
var stuck_timer = Timer.new()
var stuck_timeout = 5.0

func start():
	_setup()
	
func _setup():
	navigation_node = CommonFunctions.navigation_node
	randomize()
	wander_timer.connect("timeout", self, "_on_wander_timer_timeout")
	add_child(stuck_timer)


func _physics_process(delta):
	if !is_waiting:
		# Check if we've reached the current destination
		if current_destination == null or (parent_node.global_position - nav_agent.get_next_location()).length() < 5 or stuck_timer.is_stopped():
			# Pause movement and wait for a bit
			is_waiting = true
			wander_timer.start(rand_range(0.5, 2.5))
		else:
			# Move towards the current destination
			target = parent_node.global_position.direction_to(nav_agent.get_next_location())
			direction = target + parent_node.push_vector
			if target.x > 0:
				parent_node.anim_tree.travel("R_Walk")
			else:
				parent_node.anim_tree.travel("L_Walk")
			parent_node.move_and_slide(direction * parent_node.movement_speed)
	else:
		# We're waiting, so no movement
		if parent_node.facing_right:
			parent_node.anim_tree.travel("R_Idle")
		else:
			parent_node.anim_tree.travel("L_Idle")

func _on_wander_timer_timeout():
	# Choose a new destination
	var random_distance = rand_range(min_distance, max_distance)
	var random_angle = rand_range(0, 2 * PI)
	current_destination = parent_node.starting_position + Vector2(random_distance, 0).rotated(random_angle)
	current_destination = navigation_node.get_closest_point(current_destination)
	# Set the new destination for the navigation agent
	nav_agent.set_target_location(current_destination)
	# Resume movement
	is_waiting = false
	stuck_timer.start(stuck_timeout)
