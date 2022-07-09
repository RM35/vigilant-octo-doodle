extends Node2D

func _on_Tween_tween_completed(object, key):
	visible = false

func show_hits(damage):
	$RichText.text = str(damage)
	visible = true
	$Tween.interpolate_property(self, "position", self.position, self.position + Vector2(0, -10), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
