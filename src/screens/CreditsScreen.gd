extends Control

onready var item_list = $ItemList


func _ready() -> void:
	set_profile()

func set_profile():
	item_list.remove_item(3)
	item_list.remove_item(3)
	item_list.set_item_text(0, "Realizzato da:")
	item_list.set_item_text(1, "Matteo Massaro")
	item_list.set_item_text(2, "Nicolas Visci")



func _on_BackButton_pressed():
	get_tree().change_scene("res://src/screens/MenuScreen.tscn")
