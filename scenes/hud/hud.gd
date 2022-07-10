extends CanvasLayer

var time = 0

func _process(delta):
	time += delta
	$Score.text = str("%3.0f" % GlobalData.score)
	$Time.text = str("%3.0f" % time)
