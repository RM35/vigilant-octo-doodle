extends Node2D

onready var player = get_node("../Player")
var xp = 10
var speed = 100

func _process(delta):
	if global_position.distance_to(player.global_position) <= 200:
		var dir = global_position.direction_to(player.global_position)
		global_position = global_position  + (dir * speed * delta)
		
func collected():
	$AudioStreamPlayer2D.play()
	$Sprite.visible = false
	yield($AudioStreamPlayer2D, "finished")
	queue_free()

func _on_Area2D_body_entered(body):
	if body.has_method("collect_gem"):
		body.collect_gem(xp)
		collected()
