extends CharacterBody2D


var movement_speed = 40.0
var hp = 80
var maxhp = 80
var last_movement = Vector2.UP

var experience = 0
var experience_level = 1
var collected_experience = 0

# Attacks
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var flyingSword = preload("res://Player/Attack/flying_sword.tscn")

# AttackNodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")
@onready var tornadoTimer = get_node("%TornadoTimer")
@onready var tornadoAttackTimer = get_node("%TorandoAttackTimer")
@onready var flyingSwordBase = get_node("%FlyingSwordBase")

# UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

# Ice Spear
var icespear_ammo = 0
var icespear_baseammo = 0
var icespear_attackspeed = 1.5
var icespear_level = 0 #Level has to be 1 in order to use.

# Tornado
var tornado_ammo = 0
var tornado_baseammo = 0
var tornado_attackspeed = 3
var tornado_level = 0 #Level has to be 1 in order to use.

# Flying Sword
var flyingsword_ammo = 0
var flyingsword_level = 0 #Level has to be 1 in order to use.

#Enemy Related
var enemy_close = []

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lblLevel = get_node("%Label_Level")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var itemOptions = preload("res://Utility/item_option.tscn")
@onready var snd_LevelUp = get_node("%sound_levelup")


func _ready():
	upgrade_character("flyingsword1")
	attack()
	set_expBar(experience, calculate_experiencecap())

func _physics_process(delta):
	movement()

func movement() -> void:
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	
	if mov != Vector2.ZERO:
		last_movement = mov
	
	velocity = mov.normalized()*movement_speed
	move_and_slide()

func attack() -> void:
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed * (1 - spell_cooldown)
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()
	if tornado_level > 0:
		tornadoTimer.wait_time = tornado_attackspeed * (1 - spell_cooldown)
		if tornadoTimer.is_stopped():
			tornadoTimer.start()
	if flyingsword_level > 0:
		spawn_flyingsword()

func _on_hurt_box_hurt(damage, _angle, _knockback) -> void:
	hp -= clamp(damage - armor, 1.0, 999.0)
	print(hp)


func _on_ice_spear_timer_timeout() -> void:
	icespear_ammo += icespear_baseammo + additional_attacks
	iceSpearAttackTimer.start()


func _on_ice_spear_attack_timer_timeout() -> void:
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


func _on_tornado_timer_timeout() -> void:
	tornado_ammo += tornado_baseammo + additional_attacks
	tornadoAttackTimer.start()

func _on_torando_attack_timer_timeout() -> void:
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornadoAttackTimer.start()
		else:
			tornadoAttackTimer.stop()


func spawn_flyingsword():
	var get_flyingsword_total = flyingSwordBase.get_child_count()
	var calc_spawns = (flyingsword_ammo + additional_attacks) - get_flyingsword_total
	while calc_spawns > 0:
		var flyingsword_spawn = flyingSword.instantiate()
		flyingsword_spawn.global_position = global_position
		flyingSwordBase.add_child(flyingsword_spawn)
		calc_spawns -= 1
	#Update Flying Sword
	var get_flyingswords = flyingSwordBase.get_children()
	for i in get_flyingswords:
		if i.has_method("update_flyingsword"):
			i.update_flyingsword()

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
		experience = 0
		exp_required = calculate_experiencecap()
		levelup()
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

# LevelUp Functions
func levelup():
	snd_LevelUp.play()
	lblLevel.text = str("Level: ", experience_level)
	var tween = levelPanel.create_tween()
	#Animation for Level up to slide into the screen from the right
	tween.tween_property(levelPanel, "position", Vector2(220, 50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN) 
	tween.play()
	levelPanel.visible = true #LevelPanel is invisible by default
	var options = 0
	var optionsmax = 3
	while options < optionsmax: #Displays Options in LevelUpPanel on UpgradeOptions node
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true #Pauses game

func upgrade_character(upgrade):
	match upgrade:
		"icespear1":
			icespear_level = 1
			icespear_baseammo += 1
		"icespear2":
			icespear_level = 2
			icespear_baseammo += 1
		"icespear3":
			icespear_level = 3
		"icespear4":
			icespear_level = 4
			icespear_baseammo += 2
		"tornado1":
			tornado_level = 1
			tornado_baseammo += 1
		"tornado2":
			tornado_level = 2
			tornado_baseammo += 1
		"tornado3":
			tornado_level = 3
			tornado_attackspeed -= 0.5
		"tornado4":
			tornado_level = 4
			tornado_baseammo += 1
		"flyingsword1":
			flyingsword_level = 1
			flyingsword_ammo = 1
		"flyingsword2":
			flyingsword_level = 2
		"flyingsword3":
			flyingsword_level = 3
		"flyingsword4":
			flyingsword_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 1
		"boots1","boots2","boots3","boots4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"hourglass1","hourglass2","hourglass3","hourglass4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp, 0, maxhp)
	
	attack()
	var option_chidren = upgradeOptions.get_children()
	for i in option_chidren:
		i.queue_free()
	upgrade_options.clear() #Clear the array of options after making a choice
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800, 50) #Move LevelUpPanel off screen
	get_tree().paused = false
	calculate_experience(0) #Required to Level Up multiple times with excess experience

func get_random_item(): #Chooses eligible items from the database
	var dblist = []
	for i in UpgradeDb.UPGRADES: #Determines eligibility
		if i in collected_upgrades: #Find already collected upgrades
			pass
		elif i in upgrade_options: #If the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #Dont pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #check for prerequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add == true: #A fix so that if there are multiple prequisites then it wont add multiple times
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomItem = dblist.pick_random()
		upgrade_options.append(randomItem)
		return randomItem
	else:
		return null
