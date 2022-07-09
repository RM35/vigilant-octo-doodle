extends Node2D

onready var player = get_parent().get_parent()

# Upgradable
onready var damage = get_parent().damage
onready var rot_speed = get_parent().rot_speed
onready var spin_range = get_parent().spin_range

func _process(delta):
	$SpinningBase/SpinningNode.position.x = spin_range
	$SpinningBase.rotate(rot_speed * delta)
	$Sprite.rotate(rot_speed * 3 * delta)

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)

