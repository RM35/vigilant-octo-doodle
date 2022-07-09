extends CanvasLayer

func _process(delta):
	$Score.text = str(GlobalData.score)
