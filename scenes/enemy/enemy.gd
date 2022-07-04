extends KinematicBody2D

const SPEED = 35
const KNOCKBACK_AMOUNT = -20

onready var player = get_node("../Player")
var velocity = Vector2.ZERO
var knock_back = false
var knockbackable = true

func _physics_process(delta):
	velocity = Vector2.ZERO
	velocity = global_position.direction_to(player.position) * SPEED
	if knock_back && knockbackable:
		move_and_slide(KNOCKBACK_AMOUNT * velocity)
		knock_back = false
	else:
		move_and_slide(velocity)
		handle_collisions()

func handle_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print("Collision with: ", collision.collider.name)
