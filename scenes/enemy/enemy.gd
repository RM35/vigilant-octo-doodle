extends KinematicBody2D

onready var player = get_node("../Player")
var u_data: Resource = load("res://scenes/enemy/enemy_data/carrot.tres")
var velocity = Vector2.ZERO
var knock_back = false

func _ready():
	$Sprite.texture = u_data.texture

func _physics_process(delta):
	velocity = Vector2.ZERO
	velocity = global_position.direction_to(player.position) * u_data.speed
	if knock_back && u_data.knockbackable:
		move_and_slide(u_data.knockback_amount * velocity)
		knock_back = false
	else:
		move_and_slide(velocity)
		handle_collisions()

func handle_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print("Collision with: ", collision.collider.name)
