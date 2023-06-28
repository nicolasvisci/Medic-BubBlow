tool
extends Button

export(String, FILE) var next_scene_path: = ""

var positions

func _on_button_down():
	self.rect_scale = Vector2(0.8, 0.8)

func _on_button_up():
	self.rect_scale = Vector2(1, 1)
	get_tree().change_scene(next_scene_path)

func _get_configuration_warning():
	return "next_scene_path deve essere impostato per far funzionare il pulsante" if next_scene_path == "" else ""


func _on_DetailsButton_pressed():
	if(PlayerData.first_mode == true || PlayerData.second_mode == true || PlayerData.third_mode == true):
		PlayerData.game_flag = positions
		get_tree().change_scene("res://src/screens/UserDataScreen.tscn")

func set_user(position: int):
	positions = position - 1
