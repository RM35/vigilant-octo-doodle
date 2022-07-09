extends Control

func _ready():
	get_available_levels()
	GlobalData.selected_level = $CC/VB/OptionButton.get_item_text(0)
	
func get_available_levels():
	var dir = Directory.new()
	var levels = []
	if dir.open("res://scenes/spawner/levels/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		print(file_name)
		while file_name != "":
			if !dir.current_is_dir():
				levels.append(file_name)
			file_name = dir.get_next()
	for level in levels:
		$CC/VB/OptionButton.add_item(level)
	
func _on_Play_pressed():
	get_tree().change_scene("res://scenes/world/world.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_OptionButton_item_selected(index):
	GlobalData.selected_level = $CC/VB/OptionButton.get_item_text(index)
	print(GlobalData.selected_level)
