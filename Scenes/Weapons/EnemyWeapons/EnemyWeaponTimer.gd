extends Position2D

onready var attack_timer = $AttackTimer
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var anim_state_machine = anim_tree["parameters/playback"]
onready var parent_node = $"../.."
signal arrow_shot
signal attack_finished

