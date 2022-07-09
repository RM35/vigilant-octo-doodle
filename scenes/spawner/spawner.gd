extends Node

onready var recurring = preload("res://scenes/spawner/recurring_wave/recurring_wave.tscn")
onready var enemy = preload("res://scenes/enemy/enemy.tscn")
onready var player = get_node("../Player")
var rng = RandomNumberGenerator.new()
var elapsed_time: int = 0

var level = []
var level_stage = 0

func get_new_global_spawn_pos():
	var random_direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
	$Debug.clear_points()
	$Debug.add_point(player.global_position)
	$Debug.add_point((random_direction * 100) + player.global_position)
	return (random_direction * 100) + player.global_position
	
func _ready():
	load_level("res://scenes/spawner/levels/" + 
				GlobalData.selected_level)
	print("res://scenes/spawner/levels/" + 
				GlobalData.selected_level)

func load_level(json_path):
	var file = File.new()
	file.open(json_path, file.READ)
	level = parse_json(file.get_as_text())
	file.close()
	
func spawn(type):
	var newenemy: enemy = enemy.instance()
	newenemy.global_position = get_new_global_spawn_pos()
	newenemy.set_enemy_type("res://scenes/enemy/enemy_data/" + type)
	add_child(newenemy)
	
func _process(delta):
	pass

# Level info parsing and spawing
func _on_Timer_timeout():
	elapsed_time += $Timer.wait_time
	if len(level) - 1 < level_stage: return
	if elapsed_time > level[level_stage]['start']:
		if level[level_stage]['type'] == "recurring":
			var rec = recurring.instance()
			rec.level = level[level_stage] 
			add_child(rec)
		elif level[level_stage]['type'] == "oneshot":
			for i in range(level[level_stage]['amount']):
				spawn(level[level_stage]['enemy'])
		level_stage += 1
