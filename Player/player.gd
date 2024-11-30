extends CharacterBody2D


var movement_speed = 400.0
var hp = 80

var experience = 0
var experience_level = 1
var collected_experience = 0

# Attacks
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")

# AttackNodes
@onready var iceSpearTimer = get_node("Attack/IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("Attack/IceSpearTimer/IceSpearAttackTimer")

# Ice Spear
var icespear_ammo = 0
var icespear_baseammo = 1
var icespear_attackspeed = 1.5
var icespear_level = 1

#Enemy Related
var enemy_close = []

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lblLevel = get_node("%Label_Level")

func _ready():
	attack()
	set_expBar(experience, calculate_experiencecap())
	


func _physics_process(delta):
	movement()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	velocity = mov.normalized()*movement_speed
	move_and_slide()

func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()

func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= damage
	print(hp)


func _on_ice_spear_timer_timeout():
	icespear_ammo += icespear_baseammo
	iceSpearAttackTimer.start()


func _on_ice_spear_attack_timer_timeout():
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()

func get_random_target(): # This should be temporary. We should target closest.
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)

func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #check if level up
		collected_experience -= exp_required - experience
		experience_level += 1
		lblLevel.text = str("Level: ", experience_level)
		experience = 0
		exp_required = calculate_experiencecap()
		calculate_experience(0) # Required to Level Up multiple times with excess experience
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_expBar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap = 95 * (experience_level - 19) * 8
	else:
		exp_cap = 255 + (experience_level - 39) * 12
	
	return exp_cap

func set_expBar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value
