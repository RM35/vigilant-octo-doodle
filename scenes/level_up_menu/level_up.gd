extends CanvasLayer

onready var player = get_parent()
onready var knife_controller = get_node("../Knives")
onready var shuriken_controller = get_node("../Shurikens")

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
			knife_controller.add_knife()
		"+1 Shuriken":
			shuriken_controller.add_shuriken()
		"Refill HP":
			player.health = 100
		"+ Knife Speed":
			knife_controller.change_speed(1.05)
		"+ Knife Damage":
			knife_controller.change_damage(1.05)
		"+ Shuriken Damage":
			shuriken_controller.change_damage(1.05)
		"+ Shuriken Spin Speed":
			shuriken_controller.change_rot_speed(1.05)
		"+ Shuriken Spin Range":
			shuriken_controller.change_spin_range(1.05)
		
	$MC.visible = false
	get_tree().paused = false
	
