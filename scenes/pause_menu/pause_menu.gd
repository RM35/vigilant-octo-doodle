extends CanvasLayer

var pause_held = false

func _process(delta):
	var pause = Input.is_action_pressed("pausemenu")
	if pause && !pause_held:
		get_tree().paused = !get_tree().paused
		$MC.visible = !$MC.visible
	pause_held = pause
