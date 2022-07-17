extends CanvasLayer

func _on_MainMenu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
