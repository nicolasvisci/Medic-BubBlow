extends Button


func _on_button_down():
	self.rect_scale = Vector2(0.8, 0.8)

func _on_button_up():
	self.rect_scale = Vector2(1, 1)
	PlayerData.resume_game()

func _on_RestartButton_pressed():
	PlayerData.reset()
	if PlayerData.game_mode == 1:
		get_tree().change_scene("res://src/games/Game1.tscn")
	elif PlayerData.game_mode == 2:
		get_tree().change_scene("res://src/games/Game2.tscn")
	PlayerData.reset()
