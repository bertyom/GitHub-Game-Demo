extends Area2D

func _ready():
	connect("body_entered", $"..", "_on_InteractionRadius_body_entered")
	connect("body_exited", $"..", "_on_InteractionRadius_body_exited")
