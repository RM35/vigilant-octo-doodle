extends KinematicBody2D

const ACCELERATION = 2000
const MAX_SPEED = 100

var motion = Vector2.ZERO
var health = 100
var xp = 0
var player_level = 0
var xp_growth_rate = 100
onready var xp_to_level = calc_xp_to_lvl()

func _ready():
	pass
	
func calc_xp_to_lvl():
	return 100 + (pow((player_level / 2), 2) * xp_growth_rate)
	
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
	xp = 0
	player_level += 1
	xp_to_level = calc_xp_to_lvl()
	$XP/CC/PBXP.max_value = xp_to_level
	$LevelUp.visible = true
	$LevelUp.roll_upgrades()
	get_tree().paused = true
	

func end_level():
	print(end_level())
		
func _on_PBHP_changed():
	if health <= 0:
		end_level()

func collect_gem(xp_amount):
	xp += xp_amount
	if xp >= xp_to_level:
		level_up()
