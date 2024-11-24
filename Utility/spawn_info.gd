extends Resource

class_name Spawn_info

@export var time_start:int           # When to spawn
@export var time_end:int             # When to spawn
@export var enemy:Resource           # What enemy is meant to spawn
@export var enemy_num:int            # Number of enemies that spawn
@export var enemy_spawn_delay:int    # Seconds of delay between spawns

var spawn_delay_counter = 0          # Tracks the delayed seconds
