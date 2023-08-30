extends KinematicBody2D

export(Curve) var acceleration = null
export(Curve) var dash = null
var timer = 0
export(Resource) var weapon_node
var timer_add = 0
var current_speed = 0
var facing_same_direction = true
var can_dash = true
var dash_vector = Vector2.ZERO
var mouse_vector
var direction
var knockback_velocity = Vector2()
var push_vector
onready var dash_ghost_root = preload("res://Scenes/Effects/DashGhost.tscn")
onready var dash_ghost
var input_vector = Vector2.ZERO
var move_controls_locked = false
onready var body_sprite = $YSort/BodySprite
onready var cont_melee = $YSort/BodySprite/MeleeContainer
onready var cont_ranged = $YSort/BodySprite/RangedContainer
onready var cont_armor = $YSort/BodySprite/ArmorContainer
var inventory_open = false
onready var bodyanim = $YSort/BodySprite/AnimationTree
onready var body_anim_player = $YSort/BodySprite/AnimationPlayer
onready var body_state_machine = bodyanim["parameters/playback"]
var current_melee_name
var current_melee_node
onready var old_melee_node = null
var weapon_blend_melee
var attackTimer_melee
var state_machine_melee
var anim_player_melee
var current_ranged_name
var current_ranged_node
onready var old_ranged_node = null
var weapon_blend_ranged
var weapon_name
var attackTimer_ranged
var state_machine_ranged
var anim_player_ranged
var can_attack = true
var can_aim = true
var wound_up = false
var attacking = false
var projectile_type
var projectile_root_scene
var projectile_instance
var attack_timer
var weapon_state_machine
var anim_player
onready var timers = $TimerContainer
signal interaction_pressed
enum WeaponState {Melee, Ranged, None}
var current_shown_weapon = WeaponState.None
enum MovingState {Walk, Sprint, WoundUp}
onready var player_hurtbox = $PlayerHurtbox
onready var soft_collision = $SoftCollision

func _ready():
	PlayerData.player_node = self
	_get_current_melee()
	_get_current_ranged()
	
func _interact():
	if Input.is_action_just_pressed("ui_accept"):
		if ActionSignaler.interactable_body != null:
			if ActionSignaler.interaction_already_running == false:
				ActionSignaler.interactable_body.call_deferred("_on_PlayerInteracted")
			
func _update_armor():
	for child in cont_armor.get_children():
		if PlayerData.equipment_data[str(child.name)] != null:
			var armor_name = GameData.item_data[str(PlayerData.equipment_data[str(child.name)])]["Name"]
			child.texture = load("res://Images/Armor/" + armor_name + ".png")
			child.centered = body_sprite.centered
			child.vframes = body_sprite.vframes
			child.hframes = body_sprite.hframes
		else:
			child.texture = null


func _weapon_change(): #Changing equipped (shown) weapon
	if can_attack:
		match current_shown_weapon:
			WeaponState.Melee:
				if Input.is_action_just_pressed("melee_equip"):
					_set_weapon_visibility(false, false)
					current_shown_weapon = WeaponState.None
				elif Input.is_action_just_pressed("ranged_equip"):
					_set_weapon_visibility(false, true)
					current_shown_weapon = WeaponState.Ranged
			WeaponState.Ranged:
				if Input.is_action_just_pressed("melee_equip"):
					_set_weapon_visibility(true, false)
					current_shown_weapon = WeaponState.Melee
				elif Input.is_action_just_pressed("ranged_equip"):
					_set_weapon_visibility(false, false)
					current_shown_weapon = WeaponState.None
			WeaponState.None:
				if Input.is_action_just_pressed("melee_equip"):
					_set_weapon_visibility(true, false)
					current_shown_weapon = WeaponState.Melee
				elif Input.is_action_just_pressed("ranged_equip"):
					_set_weapon_visibility(false, true)
					current_shown_weapon = WeaponState.Ranged

func _set_weapon_visibility(show_melee: bool, show_ranged: bool):
		current_melee_node.visible = show_melee
		current_ranged_node.visible = show_ranged

func _get_current_melee(): #Get weapon in melee slot of inventory, set variables
	if PlayerData.equipment_data["WeaponMeleeSlot"] != null:
		current_melee_name = GameData.item_data[str(PlayerData.equipment_data["WeaponMeleeSlot"])]["Name"]
		current_melee_node = cont_melee.get_node(current_melee_name)
		weapon_blend_melee = current_melee_node.get_node("AnimationTree")
		attackTimer_melee = current_melee_node.get_node("AttackTimer")
		state_machine_melee = weapon_blend_melee["parameters/playback"]
		anim_player_melee = current_melee_node.get_node("AnimationPlayer")
		if current_melee_node.get_node("AttackTimer").is_connected("timeout", self, "_on_AttackTimer_timeout") == false:
			current_melee_node.get_node("AttackTimer").connect("timeout", self, "_on_AttackTimer_timeout")
	else:
		current_melee_node = $YSort/BodySprite/MeleeContainer/None

	if old_melee_node != current_melee_node and old_melee_node != null and old_melee_node != $YSort/BodySprite/MeleeContainer/None:
		if current_shown_weapon == WeaponState.Melee:
			current_melee_node.visible = true
		old_melee_node.visible = false
		if old_melee_node.get_node("AttackTimer").is_connected("timeout", self, "_on_AttackTimer_timeout") == true:
			old_melee_node.get_node("AttackTimer").disconnect("timeout", self, "_on_AttackTimer_timeout")
	
func _get_current_ranged():  #Get weapon in ranged slot of inventory, set variables
	if PlayerData.equipment_data["WeaponRangedSlot"] != null:
		current_ranged_name = GameData.item_data[str(PlayerData.equipment_data["WeaponRangedSlot"])]["Name"]
		current_ranged_node = cont_ranged.get_node(current_ranged_name)
		weapon_blend_ranged = current_ranged_node.get_node("AnimationTree")
		attackTimer_ranged = current_ranged_node.get_node("AttackTimer")
		state_machine_ranged = weapon_blend_ranged["parameters/playback"]
		anim_player_ranged = current_ranged_node.get_node("AnimationPlayer")
		if current_ranged_node.get_node("AttackTimer").is_connected("timeout", self, "_on_AttackTimer_timeout") == false:
			current_ranged_node.get_node("AttackTimer").connect("timeout", self, "_on_AttackTimer_timeout")
		projectile_type = GameData.item_data[str(PlayerData.equipment_data["WeaponRangedSlot"])]["ProjectileType"]
		match projectile_type:
			"Arrow":
				projectile_root_scene = preload("res://Scenes/Weapons/Projectiles/ArrowEntity.tscn")
			"FireBolt":
				projectile_root_scene = preload("res://Scenes/Weapons/Projectiles/FireBoltEntity.tscn")
	else:
		current_ranged_node = $YSort/BodySprite/RangedContainer/None

	if old_ranged_node != current_ranged_node and old_ranged_node != null and old_ranged_node != $YSort/BodySprite/RangedContainer/None:
		if current_shown_weapon == WeaponState.Ranged:
			current_ranged_node.visible = true
		old_ranged_node.visible = false
		if old_ranged_node.get_node("AttackTimer").is_connected("timeout", self, "_on_AttackTimer_timeout") == true:
			old_ranged_node.get_node("AttackTimer").disconnect("timeout", self, "_on_AttackTimer_timeout")
			
func _attack_melee():
	if current_melee_node != $YSort/BodySprite/MeleeContainer/None: #Checks if the right inventory slot is occupied
		if can_attack == true:
			mouse_vector = (get_global_mouse_position() - cont_melee.global_position).normalized()
			if mouse_vector.x >= 0:
				state_machine_melee.travel("WeaponRight")
				body_sprite.flip_h = false
				for child in cont_armor.get_children():
					child.flip_h = false
				weapon_blend_melee.set("parameters/WeaponRight/blend_position", mouse_vector)
				weapon_blend_melee.set("parameters/AttackRight/blend_position", mouse_vector)
				weapon_blend_melee.set("parameters/WindupRight/blend_position", mouse_vector)
			else:
				state_machine_melee.travel("WeaponLeft")
				body_sprite.flip_h = true
				for child in cont_armor.get_children():
					child.flip_h = true
				weapon_blend_melee.set("parameters/WeaponLeft/blend_position", mouse_vector)
				weapon_blend_melee.set("parameters/AttackLeft/blend_position", mouse_vector)
				weapon_blend_melee.set("parameters/WindupLeft/blend_position", mouse_vector)
				
		if can_attack==true and Input.is_action_just_pressed("attack"):
			can_dash = false
			can_attack = false
			wound_up = true
			if mouse_vector.x >= 0:
				state_machine_melee.travel("WindupRight")
			else:
				state_machine_melee.travel("WindupLeft")

		if wound_up==true and Input.is_action_just_released("attack"):
			wound_up = false
			if mouse_vector.x >= 0:
				state_machine_melee.travel("AttackRight")
			else:
				state_machine_melee.travel("AttackLeft")
			attackTimer_melee.start()
	else:
		current_shown_weapon = WeaponState.None
		
func _attack_ranged():
	if current_ranged_node != $YSort/BodySprite/RangedContainer/None: #Checks if the left inventory slot is occupied
		if can_attack == true:
			mouse_vector = (get_global_mouse_position() - cont_ranged.global_position).normalized()
			if mouse_vector.x >= 0:
				state_machine_ranged.travel("WeaponRight")
				body_sprite.flip_h = false
				for child in cont_armor.get_children():
					child.flip_h = false
				weapon_blend_ranged.set("parameters/WeaponRight/blend_position", mouse_vector)
				weapon_blend_ranged.set("parameters/AttackRight/blend_position", mouse_vector)
				weapon_blend_ranged.set("parameters/WindupRight/blend_position", mouse_vector)
			else:
				state_machine_ranged.travel("WeaponLeft")
				body_sprite.flip_h = true
				for child in cont_armor.get_children():
					child.flip_h = true
				weapon_blend_ranged.set("parameters/WeaponLeft/blend_position", mouse_vector)
				weapon_blend_ranged.set("parameters/AttackLeft/blend_position", mouse_vector)
				weapon_blend_ranged.set("parameters/WindupLeft/blend_position", mouse_vector)
				
		if can_attack==true and Input.is_action_just_pressed("attack"):
			can_dash = false
			can_attack = false
			wound_up = true
			if mouse_vector.x >= 0:
				state_machine_ranged.travel("WindupRight")
			else:
				state_machine_ranged.travel("WindupLeft")

		if wound_up==true:
			can_dash = false
			mouse_vector = (get_global_mouse_position() - cont_ranged.global_position).normalized()
			if mouse_vector.x >= 0:
				weapon_blend_ranged.set("parameters/AttackRight/blend_position", mouse_vector)
				weapon_blend_ranged.set("parameters/WindupRight/blend_position", mouse_vector)
			else:
				weapon_blend_ranged.set("parameters/AttackLeft/blend_position", mouse_vector)
				weapon_blend_ranged.set("parameters/WindupLeft/blend_position", mouse_vector)
				
		if wound_up==true and Input.is_action_just_released("attack"):
			projectile_instance = projectile_root_scene.instance()
			wound_up = false
			if mouse_vector.x >= 0:
				state_machine_ranged.travel("AttackRight")
			else:
				state_machine_ranged.travel("AttackLeft")
			projectile_instance.position = current_ranged_node.get_node("ProjectileStart").get_global_position()
			projectile_instance.rotation = current_ranged_node.rotation
			get_parent().add_child(projectile_instance)
			attackTimer_ranged.start()
	else:
		current_shown_weapon = WeaponState.None


func _attack_none():
	if can_attack == true:
		mouse_vector = (get_global_mouse_position() - global_position).normalized()
		if mouse_vector.x >= 0:
			body_sprite.flip_h = false
			for child in cont_armor.get_children():
				child.flip_h = false
		else:
			body_sprite.flip_h = true
			for child in cont_armor.get_children():
				child.flip_h = true

func _accel_decel(timer_add):
		timer+=timer_add
		timer = clamp(timer, 0, 1)
		current_speed = acceleration.interpolate(timer)

func _dash(delta):
	if move_controls_locked == false and inventory_open == false and can_dash == true and wound_up == false:
		if Input.is_action_just_pressed("dash"):
			dash_ghost = dash_ghost_root.instance()
			dash_ghost.position = get_global_position()
			dash_ghost.get_node("Ghost").flip_h = body_sprite.flip_h
			can_dash = false
			move_controls_locked = true
			player_hurtbox.get_node("CollisionShape2D").disabled = true
			match facing_same_direction:
				false:
					body_state_machine.travel("DashBackwards")
					dash_ghost.get_node("AnimationPlayer").play("DisappearBack")
				true:
					body_state_machine.travel("DashForward")
					dash_ghost.get_node("AnimationPlayer").play("DisappearForward")
			get_parent().add_child(dash_ghost)
			timers.get_node("DashDuration").start()
			if timers.get_node("DashDuration").is_stopped() == false:
				if input_vector != Vector2.ZERO:
					move_and_slide(input_vector*delta*250000)
				else:
					move_and_slide(mouse_vector*delta*250000)
	#handle can_dash and others with signals

func _get_soft_collision_vector():
	push_vector = soft_collision.get_push_vector()

func _get_damaged(damage):
	CommonFunctions.update_health(-damage)

func _get_knockback(knockback, hit_position):
	var knocback_vector = (self.global_position - hit_position).normalized()
	knockback_velocity = knocback_vector * knockback * 500

func _physics_process(delta):
	if knockback_velocity.length() > 0:
		var motion = knockback_velocity * delta
		move_and_slide(motion)
		knockback_velocity = knockback_velocity.linear_interpolate(Vector2.ZERO, 5 * delta)

	_get_soft_collision_vector()
	#movement input and mouse vector comparison
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector=input_vector.normalized()
	if (input_vector.x > 0 and mouse_vector.x < 0) or (input_vector.x < 0 and mouse_vector.x > 0):
		facing_same_direction = false
	else:
		facing_same_direction = true
	
	#movement for player kinematic body
	match move_controls_locked:
		false:
			if input_vector != Vector2.ZERO:
				_accel_decel(0.1)
				match facing_same_direction:
					false:
						body_state_machine.travel("WalkReversed")
					true:
						body_state_machine.travel("Walk")
			else:
				_accel_decel(-0.1)
				body_state_machine.travel("Idle")

#ADD switching enums for walking
			direction = input_vector*delta*current_speed
			direction += push_vector
			if Input.is_action_pressed("run"):
				move_and_slide(direction*25)
			elif wound_up == true:
				move_and_slide(direction*5)
			elif facing_same_direction == false:
				move_and_slide(direction*10)
			else:
				move_and_slide(direction*15)
		true:
			pass
	
	#monitors space to dash
	_dash(delta)
	
	#monitors F to see if interaction pressed
	_interact()
	
	#monitors for Q and E to draw/sheathe weapons
	_weapon_change()

	#attack for ranged/melee/none
	match current_shown_weapon:
		WeaponState.Melee:
			_attack_melee()
		WeaponState.Ranged:
			_attack_ranged()
		WeaponState.None:
			_attack_none()
			
#signals
func _on_AttackTimer_timeout(): #Connected on ready with weapon-specofic script
		match current_shown_weapon:
			WeaponState.Melee:
				if current_melee_node != $YSort/BodySprite/MeleeContainer/None:
					if attackTimer_melee.is_stopped() == true:
						if inventory_open == false:
							can_attack = true
					if timers.get_node("DashCooldown").is_stopped() == true:
						can_dash = true
			WeaponState.Ranged:
				if current_ranged_node != $YSort/BodySprite/RangedContainer/None:
					if attackTimer_ranged.is_stopped() == true:
						if inventory_open == false:
							can_attack = true
					if timers.get_node("DashCooldown").is_stopped() == true:
						can_dash = true
			WeaponState.None:
				pass

func _on_UI_inventory_open():
	inventory_open = true
	can_attack = false
	can_dash = false
	old_melee_node = current_melee_node
	old_ranged_node = current_ranged_node
	
func _on_UI_inventory_closed():
	inventory_open = false
	can_attack = true
	if timers.get_node("DashCooldown").is_stopped() == true:
		can_dash = true
	_get_current_melee()
	_get_current_ranged()
	_update_armor()

func _on_DashDuration_timeout():
	timers.get_node("DashCooldown").start()
	move_controls_locked = false
	player_hurtbox.get_node("CollisionShape2D").disabled = false

func _on_DashCooldown_timeout():
	can_dash = true

func _on_PlayerHurtbox_area_entered(area):
	if PlayerData.player_base_stats["health"] > 0:
		var damage = area.weapon_base_damage
		var knockback = area.weapon_base_knockback
		var hit_position = area.hit_position
		_get_damaged(damage)
		_get_knockback(knockback, hit_position)
