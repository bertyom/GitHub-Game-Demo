extends StaticBody2D

onready var sprite = $Sprite
onready var interaction_container = $InteractionContainer
var should_outline = true
export var is_container = false
export (String) var container_ID
export var should_animate = false

func _on_InteractionRadius_body_entered(body):
	if body == PlayerData.player_node and should_outline == true:
		sprite.material.set_shader_param("width", 1)
		ActionSignaler.interactable_body = interaction_container
		ActionSignaler.current_container_node = $"."
	if interaction_container.interaction_type == "Containers":
		ContainerLoot.current_container_ID = container_ID
	
func _on_InteractionRadius_body_exited(body):
	if interaction_container.interaction_type == "Containers":
		if is_instance_valid(CommonFunctions.container_node):
			CommonFunctions.container_node.queue_free()
			interaction_container.get_node("Containers")._close()
		ContainerLoot.current_container_ID = null
	if body == PlayerData.player_node:
		sprite.material.set_shader_param("width", 0)
		ActionSignaler.interactable_body = null

func _Stop_outline():
	should_outline = false
	sprite.material.set_shader_param("width", 0)
