extends KinematicBody2D

class_name enemy

onready var player = get_node("../../Player")
export var u_data: Resource = load("res://scenes/enemy/enemy_data/carrot.tres").duplicate()
onready var gem = load("res://scenes/gem/gem.tscn")
var velocity = Vector2.ZERO
var knock_back = false
var max_hp
var age = 0.0
var power
var dead = false

func _process(delta):
	$Label.text = str(power)
	age += delta
	# If just out of screen and old then kill
	if global_position.distance_to(player.global_position) > 400 && age > 60:
		queue_free()
	# If further but not killable then respawn oposite
	if global_position.distance_to(player.global_position) > 750:
		global_position += (player.global_position - global_position) + ((player.global_position - global_position).normalized() * 400)

func _ready():
	max_hp = u_data.health
	
func set_enemy_type(unit_data: String):
	u_data = load(unit_data).duplicate()
	power = clamp((u_data.health + u_data.speed + 50.0) / 100.0, 1.00, 2.00)
	$Sprite.texture = u_data.texture
	$Sprite.scale = Vector2(power, power)
	$CollisionShape2D.scale = Vector2(power, power)
	
func _physics_process(delta):
	velocity = Vector2.ZERO
	velocity = global_position.direction_to(player.position) * u_data.speed
	if knock_back && u_data.knockbackable:
		move_and_slide(u_data.knockback_amount * velocity)
		knock_back = false
	else:
		move_and_slide(velocity)
		handle_collisions()
	
#Body collisions only
func handle_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		if body.is_in_group("enemy"):
			pass

func dead():
	dead = true
	yield($AudioStreamPlayer2D, "finished")
	yield($Hitnum.get_node("Tween"), "tween_completed")
	var new_gem = gem.instance()
	new_gem.xp = max_hp + u_data.speed
	new_gem.global_position = global_position
	new_gem.get_node("Sprite").scale = Vector2(power - 0.3, power - 0.3) * 0.5
	get_parent().get_parent().get_node("Gems").add_child(new_gem)
	
	#Score
	GlobalData.score += max_hp + u_data.speed
	queue_free()
	
#Let the tween time regulate the rate damage taken
func take_damage(amount):
	if !$FlashDamage.is_active():
		
		#Hitnum
		$Hitnum.show_hits(str("%3.0f" % amount))
		
		#Check for death
		u_data.health -= amount
		if u_data.health <= 0:
			dead()
		$AudioStreamPlayer2D.play()
		knock_back = true
		var start_modulate = $Sprite.modulate
		$FlashDamage.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color(0, 0, 0), 0.05, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$FlashDamage.start()
		yield($FlashDamage, "tween_completed")
		$FlashDamage.interpolate_property($Sprite, "modulate", Color(0, 0, 0), start_modulate, 0.05, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$FlashDamage.start()
