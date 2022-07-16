extends Node2D

onready var player = get_parent().get_parent()
var dir: Vector2 = Vector2.RIGHT
var origin_vector_global = Vector2.ZERO
var player_prev_pos = Vector2.ZERO
var reset = false
var rng = RandomNumberGenerator.new()
onready var controller = get_parent()
var nearest_enemy_pos = Vector2(1000, 1000)
# Upgradable
onready var damage = controller.damage
onready var speed = controller.speed

func _ready():
	player_prev_pos = player.global_position
	$Timer.start()
	
func _process(delta):
	if !reset:
		$Line2D.clear_points()
		$Line2D.add_point(Vector2(0, 0))
		var dir
		var ene
		var dist = 2000
		for i in get_node("../../../Spawner").get_children():
			if i.is_in_group("enemy"):
				if player.global_position.distance_to(i.global_position) < dist:
					ene = i
					dist = player.global_position.distance_to(i.global_position)
		if ene != null:
			dir = (-1 * (global_position - ene.global_position)).normalized()
			$Line2D.add_point(-1 * (global_position - ene.global_position))
		else: dir = Vector2.RIGHT
		$Parts.rotation_degrees = rad2deg(dir.angle()) +90
		var offset = player_prev_pos - player.global_position
		global_position = global_position  + (dir * speed * delta) + offset
	else:
		damage = get_parent().damage
		reset = false
		$Timer.start()
		if dir.x < 0:
			$Sprite.set_scale(Vector2(-1,1))
		if dir.x > 0:
			$Sprite.set_scale(Vector2(1,1))
		origin_vector_global = player.global_position
		global_position = origin_vector_global
	player_prev_pos = player.global_position
		
func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		if damage > 0 :
			body.take_damage(damage)
			#-1 damage per penetration
			damage = clamp(damage - 1, 0, 9999)

func _on_Timer_timeout():
	reset = true
