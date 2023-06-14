extends Control
signal pressed

func _on_Button_pressed():
	emit_signal("pressed", self.get_name())
	print("prova")
	get_tree().quit()
