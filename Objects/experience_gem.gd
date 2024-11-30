extends Area2D

@export var experience = 1

var sprite_green_gem = preload("res://assets/green_gem.png")
var sprite_blue_gem = preload("res://assets/blue_gem.png")
var sprite_red_gem = preload("res://assets/red_gem.png")

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $AudioStreamPlayer

func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = sprite_blue_gem
	else:
		sprite.texture = sprite_red_gem
	

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2 * delta

func collect():
	sound.play()
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	return experience


func _on_audio_stream_player_finished(): #for future sound
	queue_free()
