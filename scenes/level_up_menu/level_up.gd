extends Control

onready var player = get_parent()
onready var knife_scn = load("res://scenes/weapon/knife/knife.tscn")
onready var shuriken_scn = load("res://scenes/weapon/shuriken/shuriken.tscn")

var upgrade: int
var upgrades: Array = ["+1 Knife", "+1 Shuriken",
					   "Refill HP", "+ Knife Speed", "+ Knife Damage",
					   "+ Shuriken Damage", "+ Shuriken Spin Speed",
					   "+ Shuriken Spin Range"]
var choice = []
var rng = RandomNumberGenerator.new()

func roll_upgrades():
	rng.randomize()
	choice = []
	for i in range(3):
		choice.append(upgrades[rng.randi_range(0, len(upgrades) - 1)])
	$MC/VB/O1.text = choice[0]
	$MC/VB/O2.text = choice[1]
	$MC/VB/O3.text = choice[2]
	
func _on_O1_pressed():
	do_upgrade(0)

func _on_O2_pressed():
	do_upgrade(1)

func _on_O3_pressed():
	do_upgrade(2)

func do_upgrade(which: int):
	match choice[which]:
		"+1 Knife":
			var newknife = knife_scn.instance()
			player.get_node("Knives").add_child(newknife)
		"+1 Shuriken":
			var newshuriken = shuriken_scn.instance()
			player.get_node("Shurikens").add_child(newshuriken)
		"Refill HP":
			player.health = 100
		"+ Knife Speed":
			for knife in player.get_node("Knives").get_children():
				knife.speed *= 1.05
		"+ Knife Damage":
			for knife in player.get_node("Knives").get_children():
				knife.damage *= 1.02
		"+ Shuriken Damage":
			for shur in player.get_node("Shurikens").get_children():
				shur.damage *= 1.02
		"+ Shuriken Spin Speed":
			for shur in player.get_node("Shurikens").get_children():
				shur.rot_speed *= 1.02
		"+ Shuriken Spin Range":
			for shur in player.get_node("Shurikens").get_children():
				shur.spin_range *= 1.02
		
	visible = false
	get_tree().paused = false
