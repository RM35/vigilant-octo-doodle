extends CanvasLayer

var time = 0

func _process(delta):
	time += delta
	GlobalData.time_survived = time
	$Score.text = str("%3.0f" % GlobalData.score)
	$Time.text = str("%3.0f" % GlobalData.time)
