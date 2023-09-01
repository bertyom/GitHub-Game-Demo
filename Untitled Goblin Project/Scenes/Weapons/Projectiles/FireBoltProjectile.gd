extends RigidBody2D

export var speed = 375
onready var trail = $AnimationPivot/Sprite/Trail
onready var anim_player = $AnimationPlayer
onready var hitbox_controller = $PlayerRangedHitbox
onready var hitbox = hitbox_controller.get_node("Hitbox")
onready var disappearTimer = $DisappearTimer

func _ready():
	apply_impulse(Vector2(), Vector2(speed, 0).rotated(rotation))
	hitbox_controller.connect("area_entered", self, "_on_PlayerRangedHitbox_area_entered")

func _on_CollsionDetecter_area_entered(area):
	set_mode(RigidBody2D.MODE_STATIC)
	set_linear_velocity(Vector2.ZERO)
	set_angular_velocity(0)
	trail.visible = false
	anim_player.play("Stuck")

func _on_PlayerRangedHitbox_area_entered(area):
	queue_free()
	
func _on_DisappearTimer_timeout():
	anim_player.play("Disappear")

func _on_VisibilityNotifier2D_screen_exited():
	disappearTimer.start()

func _on_VisibilityNotifier2D_screen_entered():
	if disappearTimer.is_stopped() == false:
		disappearTimer.stop()



