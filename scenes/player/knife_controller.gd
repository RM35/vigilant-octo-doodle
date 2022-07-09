extends Node2D

onready var knife_scn = load("res://scenes/weapon/knife/knife.tscn")

var damage = 10
var speed = 400

func add_knife():
	var newknife = knife_scn.instance()
	newknife.damage = damage
	newknife.speed = speed
	add_child(newknife)
	rebalance()

func rebalance():
	pass

func change_speed(factor):
	speed *= factor
	for knife in get_children():
		knife.speed = speed
		
func change_damage(factor):
	damage *= factor
	for knife in get_children():
		knife.damage = damage
