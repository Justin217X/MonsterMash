extends Node2D


@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

@export var time = 0

signal changetime(time)

func _ready() -> void:
	connect("changetime", Callable(player, "change_time"))

func _on_timer_timeout():
	time += 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time > i.time_start and time < i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay: # check if there is a delay
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_num: # spawn number of enemies
					var enemy_spawn = new_enemy.instantiate() #create instance of packed scene
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)
					counter += 1
	emit_signal("changetime", time) #For the timer label in player

func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4) # get viewport values and multiply them by 1.1 to 1.4 to get values a bit larger than the screen
	var top_left = Vector2(player.global_position.x - (vpr.x / 2), player.global_position.y - (vpr.y / 2))
	var top_right = Vector2(player.global_position.x + (vpr.x / 2), player.global_position.y - (vpr.y / 2))
	var bottom_left = Vector2(player.global_position.x - (vpr.x / 2), player.global_position.y + (vpr.y / 2))
	var bottom_right = Vector2(player.global_position.x + (vpr.x / 2), player.global_position.y + (vpr.y / 2))
	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)
