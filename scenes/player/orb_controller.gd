extends Node2D

onready var orb_scn = load("res://scenes/weapon/orb/orb.tscn")

var damage = 5
var speed = 180

#Rebalancing
var total_delta = 0.0
var rebalancing = false
var orb_array = []
var rebal_delay = 0.0
	
#Rebalancing within process as timers do not have enough granularity
func _process(delta):
	if rebalancing:
		total_delta += delta
		if total_delta > rebal_delay:
			if len(orb_array) > 0:
				orb_array.pop_front().get_node("Timer").start()
			else:
				rebalancing = false
			total_delta = 0
		
func add_orb():
	var neworb = orb_scn.instance()
	neworb.damage = damage
	neworb.speed = speed
	add_child(neworb)
	rebalance()

func rebalance():
	var orb_count = get_child_count()
	rebal_delay = 1.0 / orb_count
	orb_array = []
	for orb in get_children():
		orb_array.append(orb)
	rebalancing = true

func change_speed(factor, addition):
	speed *= factor
	speed += addition
	for orb in get_children():
		orb.speed = speed
		
func change_damage(factor, addition):
	damage *= factor
	damage += addition
	for orb in get_children():
		orb.damage = damage
		
func nearest_enemy():
	var closest = Vector2(1000, 1000)
	for enemy in get_node("../../Spawner").get_children():
		if enemy.is_in_group("enemy"):
			if position.distance_to(enemy.global_position) > global_position.distance_to(closest):
				closest = enemy.global_position
	return closest
			
