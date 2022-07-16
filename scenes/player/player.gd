extends KinematicBody2D

const ACCELERATION = 2000
var MAX_SPEED = 95

var motion = Vector2.ZERO
var health = 100
var xp = 0
var player_level = 0
var xp_growth_rate = 130
onready var xp_to_level = calc_xp_to_lvl()
var invincible = false

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	var select = rng.randi_range(0, 2)
	if select == 0:
		$Knives.add_knife()
	elif select == 1:
		$Shurikens.add_shuriken()
	elif select == 2:
		$Orbs.add_orb()
		
func calc_xp_to_lvl():
	return 150 + (pow((player_level / 2), 2) * xp_growth_rate)
	
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
		if body.is_in_group("enemy") && !invincible:
			health -= 1
			if health <= 0:
				end_level()

func level_up():
	xp = 0
	player_level += 1
	xp_to_level = calc_xp_to_lvl()
	$XP/CC/PBXP.max_value = xp_to_level
	$LevelUp/up.play()
	$LevelUp/MC.visible = true
	$LevelUp.roll_upgrades()
	get_tree().paused = true
	
func end_level():
	$DeathMenu/P.visible = true
	$DeathMenu/Firebase.run_end_screen()
	get_tree().paused = true

func collect_gem(xp_amount):
	xp += xp_amount
	if xp >= xp_to_level:
		level_up()


func _on_Button_pressed():
	end_level()


func _on_Invincible_pressed():
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	invincible = !invincible
	$Invincible.text = "HACKER: " + str(invincible)
	for child in $Knives.get_children():
		child.queue_free()
	for child in $Shurikens.get_children():
		child.queue_free()



func _on_DebugLevelUp_pressed():
	level_up()
