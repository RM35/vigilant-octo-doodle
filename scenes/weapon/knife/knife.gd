extends Node2D

# Knife weapon essentially travels in a straight line in the direction the
# player is facing when fired. Currently it will reset after a certain distance
# and reset its location and direction. This means that the rate of fire is
# not only time based but as a function of the players movement + time

onready var player = get_parent()
var dir: Vector2 = Vector2.RIGHT
var speed = 450
var origin_vector_global = Vector2.ZERO
var last_dir = Vector2.RIGHT
var player_prev_pos = Vector2.ZERO
var damage = 10

func _ready():
	player_prev_pos = player.global_position
	
func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	return axis.normalized()
	
func _process(delta):
	var axis = get_input_axis()
	if axis != Vector2.ZERO:
		last_dir = axis
	if self.global_position.distance_to(player.global_position) <= 400:
		var offset = player_prev_pos - player.global_position
		global_position = global_position  + (dir * speed * delta) + offset
	else:
		dir = last_dir
		if dir.x < 0:
			$Sprite.set_scale(Vector2(-1,1))
		if dir.x > 0:
			$Sprite.set_scale(Vector2(1,1))
		origin_vector_global = player.global_position
		global_position = origin_vector_global
	player_prev_pos = player.global_position
		
func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
