extends Node

onready var parent_node = $"../.."
onready var nav_agent = $"../../NavigationAgent2D"
var direction
var target_location
var navigation_node
var weapon
var target
var can_attack = true
var currently_swinging = false
export(String, "Passive", "Agressive", "None") var behaviour_type

func start():
	_setup()
	
func _setup():
	navigation_node = CommonFunctions.navigation_node
	weapon = parent_node.current_weapon
	if !weapon.attack_timer.is_connected("timeout", self, "_on_AttackTimer_timeout"):
		weapon.attack_timer.connect("timeout", self, "_on_AttackTimer_timeout")
	if !weapon.is_connected("attack_finished", self, "_on_attack_finished"):
		weapon.connect("attack_finished", self, "_on_attack_finished")


func _attack():
	can_attack = false
	if target.x >= 0:
		weapon.anim_state_machine.travel("RightWindup")
	else:
		weapon.anim_state_machine.travel("LeftWindup")
	weapon.attack_timer.start()
	currently_swinging = true


func _physics_process(delta):
	target_location = navigation_node.get_closest_point(PlayerData.player_node.global_position)
	nav_agent.set_target_location(target_location)
	target = parent_node.global_position.direction_to(nav_agent.get_next_location())
	direction = target + parent_node.push_vector

	if can_attack:
		_attack()

	# Move towards the waypoint
	if !currently_swinging:
		if target.x >= 0:
			parent_node.anim_tree.travel("R_Walk")
		else:
			parent_node.anim_tree.travel("L_Walk")
	else:
		if parent_node.facing_right:
			parent_node.anim_tree.travel("R_Walk")
		else:
			parent_node.anim_tree.travel("L_Walk")
	
	parent_node.move_and_slide(direction * parent_node.movement_speed * 0.7)

func _on_AttackTimer_timeout():
	can_attack = true

func _on_attack_finished():
	currently_swinging = false
