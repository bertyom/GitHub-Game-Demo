extends Position2D

onready var attackTimer = $AttackTimer
onready var playerNode = PlayerData.player_node
onready var anim_tree = $AnimationTree
signal arrow_shot



func _ready():
	attackTimer.connect("timeout", playerNode, "_on_AttackTimer_timeout")
