extends Control

var upgrade: int
var upgrades: Array = ["+1 Knife", "+1 Shuriken"]
var choice = []
var rng = RandomNumberGenerator.new()

func roll_upgrades():
	rng.randomize()
	choice = []
	for i in range(3):
		choice.append(upgrades[rng.randi_range(0, len(upgrades) - 1)])

func _on_O1_pressed():
	do_upgrade(0)

func _on_O2_pressed():
	do_upgrade(0)

func _on_O3_pressed():
	do_upgrade(0)

func do_upgrade(which: int):
	print("upgrading " + str(choice[which]))
	visible = false
	get_tree().paused = false
