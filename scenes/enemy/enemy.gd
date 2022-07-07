extends KinematicBody2D

class_name enemy

onready var player = get_node("../../Player")
export var u_data: Resource = load("res://scenes/enemy/enemy_data/carrot.tres")
var velocity = Vector2.ZERO
var knock_back = false

func _ready():
	pass

func set_enemy_type(unit_data: String):
	u_data = load(unit_data)
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

#Let the tween time regulate the rate damage taken
func take_damage(amount):
	if !$FlashDamage.is_active():
		$AudioStreamPlayer2D.play()
		u_data.health -= amount
		if u_data.health <= 0:
			pass #We are dead
		knock_back = true
		var start_modulate = $Sprite.modulate
		$FlashDamage.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color(0, 0, 0), 0.05, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$FlashDamage.start()
		yield($FlashDamage, "tween_completed")
		$FlashDamage.interpolate_property($Sprite, "modulate", Color(0, 0, 0), start_modulate, 0.05, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$FlashDamage.start()
