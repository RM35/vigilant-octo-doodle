extends Node2D

onready var player = get_parent()
var dir: Vector2 = Vector2.RIGHT
var speed = 250
var origin_vector_global = Vector2.ZERO
var last_dir = Vector2.RIGHT
var fire_global_origin = Vector2.ZERO

func _ready():
	fire_global_origin = player.global_position
	
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
		var offset = fire_global_origin - player.global_position
		
		global_position = global_position  + (dir * speed * delta) + offset
	else:
		dir = last_dir
		
		if dir.x < 0:
			$Sprite.set_scale(Vector2(-1,1))
		if dir.x > 0:
			$Sprite.set_scale(Vector2(1,1))
			
		origin_vector_global = player.global_position
		global_position = origin_vector_global
	fire_global_origin = player.global_position
		

