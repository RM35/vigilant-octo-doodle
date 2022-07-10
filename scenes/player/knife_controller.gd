extends Node2D

onready var knife_scn = load("res://scenes/weapon/knife/knife.tscn")

var damage = 7
var speed = 250

#Rebalancing
var total_delta = 0.0
var rebalancing = false
var knife_array = []
var rebal_delay = 0.0

#Rebalancing within process as timers do not have enough granularity
func _process(delta):
	if rebalancing:
		total_delta += delta
		if total_delta > rebal_delay:
			if len(knife_array) > 0:
				knife_array.pop_front().get_node("Timer").start()
				print("Started " + str(total_delta))
			else:
				rebalancing = false
			total_delta = 0
		
func add_knife():
	var newknife = knife_scn.instance()
	newknife.damage = damage
	newknife.speed = speed
	add_child(newknife)
	rebalance()

func rebalance():
	var knife_count = get_child_count()
	rebal_delay = 1.0 / knife_count
	knife_array = []
	for knife in get_children():
		knife_array.append(knife)
	rebalancing = true

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
