extends CanvasLayer

onready var player = get_parent()
onready var knife_controller = get_node("../Knives")
onready var shuriken_controller = get_node("../Shurikens")
onready var orb_controller = get_node("../Orbs")

const WEAPON_CAP_KNIFE = 6
const WEAPON_CAP_SHURIKEN = 6
const WEAPON_CAP_ORB = 6

var upgrade: int
var upgrades: Array = ["+1 Knife", "+1 Shuriken",
					   "Refill HP", "+ Knife Damage",
					   "+ Shuriken Damage", "+ Shuriken Spin Speed",
					   "+ Shuriken Spin Range", "+1 Orb", "+ Orb Damage"]

var choice = []
var rng = RandomNumberGenerator.new()

func roll_upgrades():
	rng.randomize()
	var temp_upgrades = upgrades.duplicate(true)
	
	#Remove +1 is weapon is at cap
	if len(knife_controller.get_children()) > WEAPON_CAP_KNIFE:
		temp_upgrades.pop_at(temp_upgrades.find("+1 Knife"))
	if len(shuriken_controller.get_children()) > WEAPON_CAP_SHURIKEN:
		temp_upgrades.pop_at(temp_upgrades.find("+1 Shuriken"))
	if len(orb_controller.get_children()) > WEAPON_CAP_ORB:
		temp_upgrades.pop_at(temp_upgrades.find("+1 Orb"))
		
	choice = []
	for i in range(3):
		choice.append(temp_upgrades.pop_at(rng.randi_range(0, len(temp_upgrades) - 1)))

	$MC/VB/O1.text = choice[0]
	$MC/VB/O2.text = choice[1]
	$MC/VB/O3.text = choice[2]
	
func _on_O1_pressed():
	$pick.play()
	do_upgrade(0)

func _on_O2_pressed():
	$pick.play()
	do_upgrade(1)

func _on_O3_pressed():
	$pick.play()
	do_upgrade(2)

func do_upgrade(which: int):
	match choice[which]:
		"+1 Knife":
			knife_controller.add_knife()
		"+1 Shuriken":
			shuriken_controller.add_shuriken()
		"Refill HP":
			player.health = 100
		"+ Knife Damage":
			knife_controller.change_damage(1.00, 1)
		"+ Shuriken Damage":
			shuriken_controller.change_damage(1.00, 1)
		"+ Shuriken Spin Speed":
			shuriken_controller.change_rot_speed(1.05, 0)
		"+ Shuriken Spin Range":
			shuriken_controller.change_spin_range(1.05, 0)
		"+1 Orb":
			orb_controller.add_orb()
		"+ Orb Damage":
			orb_controller.change_damage(1.00, 1)
			
	$MC.visible = false
	get_tree().paused = false
	
