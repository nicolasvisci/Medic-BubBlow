extends Button


func _on_button_down():
	self.rect_scale = Vector2(0.8, 0.8)

func _on_button_up():
	self.rect_scale = Vector2(1, 1)
	get_tree().quit()
