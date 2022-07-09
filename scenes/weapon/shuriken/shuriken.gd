extends Node2D

onready var player = get_parent().get_parent()

# Upgradable
var damage = 100
var rot_speed = 2
var spin_range = 50

func _process(delta):
	$SpinningBase/SpinningNode.position.x = spin_range
	$SpinningBase.rotate(rot_speed * delta)
	$Sprite.rotate(rot_speed * 3 * delta)

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)

