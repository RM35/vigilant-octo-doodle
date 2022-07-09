extends CanvasLayer

var pause_held = false
onready var player = get_node("../Player")

func _process(delta):
	var pause = Input.is_action_pressed("pausemenu")
	if pause && !pause_held:
		update_stats()
		get_tree().paused = !get_tree().paused
		$MC.visible = !$MC.visible
	pause_held = pause
	
func _on_Resume_pressed():
	get_tree().paused = false
	$MC.visible = false

func _on_ExittoMM_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
	
func update_stats():
	var sp = $MC/VB/StatPanel
	sp.text = "Current Stats:\n"
	sp.text += "Level: " + str(player.player_level) + "\n"
	sp.text += "XP: " + str(player.xp) + "/" + str(player.xp_to_level) + "\n\n"
	sp.text += "Shuriken:\n"
	sp.text += "Damage: " + str(player.get_node("Shurikens").damage) + "\n"
	sp.text += "Rotate Speed: " + str(player.get_node("Shurikens").rot_speed) + "\n"
	sp.text += "Sping Range: " + str(player.get_node("Shurikens").spin_range) + "\n\n"
	sp.text += "Knife:\n"
	sp.text += "Damage: " + str(player.get_node("Knives").damage) + "\n"
	sp.text += "Speed: " + str(player.get_node("Knives").speed) + "\n"
