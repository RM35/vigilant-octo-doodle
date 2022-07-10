extends Node2D

onready var shur_scn = load("res://scenes/weapon/shuriken/shuriken.tscn")

var damage = 7
var rot_speed = 1.5
var spin_range = 55

func add_shuriken():
	var newshur = shur_scn.instance()
	newshur.damage = damage
	newshur.rot_speed = rot_speed
	newshur.spin_range = spin_range
	add_child(newshur)
	rebalance()
	
func rebalance():
	var shuriken_count = get_child_count()
	var each_angle = 360 / shuriken_count
	var i = 0
	for shur in get_children():
		shur.get_node("SpinningBase").rotation_degrees = each_angle * i
		i += 1

func change_damage(factor, addition):
	damage *= factor
	damage += addition
	for shur in get_children():
		shur.damage = damage

func change_rot_speed(factor, addition):
	rot_speed *= factor
	rot_speed += addition
	for shur in get_children():
		shur.rot_speed = rot_speed

func change_spin_range(factor, addition):
	spin_range *= factor
	spin_range += addition
	for shur in get_children():
		shur.spin_range = spin_range
