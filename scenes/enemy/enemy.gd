extends KinematicBody2D

class_name enemy

onready var player = get_node("../../Player")
export var u_data: Resource = load("res://scenes/enemy/enemy_data/carrot.tres").duplicate()
onready var gem = load("res://scenes/gem/gem.tscn")
var velocity = Vector2.ZERO
var knock_back = false
var max_hp
	
func _ready():
	max_hp = u_data.health
	
func set_enemy_type(unit_data: String):
	u_data = load(unit_data).duplicate()
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
	
	$Line2D.clear_points()
	$Line2D.add_point(Vector2(0, 0))
	$Line2D.add_point(velocity)
	
#Body collisions only
func handle_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		if body.is_in_group("enemy"):
			pass

func dead():
	yield($AudioStreamPlayer2D, "finished")
	yield($Hitnum.get_node("Tween"), "tween_completed")
	var new_gem = gem.instance()
	new_gem.xp = max_hp + u_data.speed
	new_gem.global_position = global_position
	get_parent().add_child(new_gem)
	
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
