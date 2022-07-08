extends KinematicBody2D

const ACCELERATION = 2000
const MAX_SPEED = 100

var motion = Vector2.ZERO
var health = 100
var xp = 0

func _physics_process(delta):
	var axis = get_input_axis()
	if axis.x < 0:
		$Sprite.set_scale(Vector2(-1,1))
	if axis.x > 0:
		$Sprite.set_scale(Vector2(1,1))
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)
	handle_collisions()

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	return axis.normalized()
	
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)

func _process(delta):
	$Health/CC/PBHP.value = health
	$XP/CC/PBXP.value = xp

func handle_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		if body.is_in_group("enemy"):
			health -= 1

func level_up():
	print("levelled up")

func end_level():
	print(end_level())
	
func _on_PBXP_changed():
	if xp >= 100:
		level_up()
		xp = 0
		
func _on_PBHP_changed():
	if health <= 0:
		end_level()

func collect_gem(xp_amount):
	xp += xp_amount
