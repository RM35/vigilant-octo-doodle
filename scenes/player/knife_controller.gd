extends Node2D

onready var knife_scn = load("res://scenes/weapon/knife/knife.tscn")

var damage = 7
var speed = 320

func add_knife():
	var newknife = knife_scn.instance()
	newknife.damage = damage
	newknife.speed = speed
	add_child(newknife)
	rebalance()

func rebalance():
	pass

func change_speed(factor, addition):
	speed *= factor
	speed += addition
	for knife in get_children():
		knife.speed = speed
		
func change_damage(factor, addition):
	damage *= factor
	damage += addition
	for knife in get_children():
		knife.damage = damage
