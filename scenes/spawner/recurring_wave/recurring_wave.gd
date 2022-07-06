extends Node

var level
var trigger_count = 0
var max_triggers: int = 0
signal spawn

func _ready():
	max_triggers = level['duration'] / level['delay']
	connect("spawn", get_node("../../Spawner"), "spawn")
	$Timer.wait_time = level['delay']
	$Timer.start()

func _on_Timer_timeout():
	trigger_count += 1
	if trigger_count <= max_triggers:
		emit_signal("spawn", level['enemy'])
	else:
		queue_free()
