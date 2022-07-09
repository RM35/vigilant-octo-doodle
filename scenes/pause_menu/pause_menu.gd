extends CanvasLayer

var pause_held = false
onready var player = get_node("../Player")

func _process(delta):
	var pause = Input.is_action_pressed("pausemenu")
	if pause && !pause_held:
		get_tree().paused = !get_tree().paused
		$MC.visible = !$MC.visible
	pause_held = pause

func _on_Resume_pressed():
	get_tree().paused = false
	$MC.visible = false

func _on_ExittoMM_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
	
