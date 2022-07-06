extends Node

onready var enemy = preload("res://scenes/enemy/enemy.tscn")
onready var player = get_node("../Player")
var rng = RandomNumberGenerator.new()

func get_new_global_spawn_pos():
	var random_direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
	$Debug.clear_points()
	$Debug.add_point(player.global_position)
	$Debug.add_point((random_direction * 100) + player.global_position)
	return (random_direction * 100) + player.global_position
	
func _ready():
	pass

func spawn():
	var newenemy: enemy = enemy.instance()
	newenemy.global_position = get_new_global_spawn_pos()
	newenemy.set_enemy_type("res://scenes/enemy/enemy_data/dan.tres")
	add_child(newenemy)
	
var cumdelta: float
func _process(delta):
	cumdelta += delta
	if cumdelta > 2:
		cumdelta = 0
		spawn()
