extends Node2D

onready var player = get_parent().get_parent()
var dir: Vector2 = Vector2.RIGHT
var origin_vector_global = Vector2.ZERO
var player_prev_pos = Vector2.ZERO
var reset = false
var rng = RandomNumberGenerator.new()
onready var controller = get_parent()
var current_target

# Upgradable
onready var damage = controller.damage
onready var speed = controller.speed

func _ready():
	player_prev_pos = player.global_position
	reset = true
	$Timer.start()
	
func _process(delta):
	if !reset:
		$Parts.rotation_degrees = rad2deg(dir.angle()) +90
		var offset = player_prev_pos - player.global_position
		global_position = global_position  + (dir * speed * delta) + offset
	else:
		visible = true
		current_target = get_nearest_enemy()
		damage = get_parent().damage
		reset = false
		$Timer.start()
		origin_vector_global = player.global_position
		global_position = origin_vector_global
		if current_target != null:
			dir = (-1 * (global_position - current_target.global_position)).normalized()
		else: dir = Vector2.RIGHT
	player_prev_pos = player.global_position
		
func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		if damage > 0 :
			body.take_damage(damage)
			#-1 damage per penetration
			damage = clamp(damage - 1, 0, 9999)
			visible = false
			current_target = null

func _on_Timer_timeout():
	reset = true

func get_nearest_enemy():
	var target = null
	var dist = 10000
	for i in get_node("../../../Spawner").get_children():
		if i.is_in_group("enemy"):
			if player.global_position.distance_to(i.global_position) < dist && i.dead == false:
				target = i
				dist = player.global_position.distance_to(i.global_position)
	return target
