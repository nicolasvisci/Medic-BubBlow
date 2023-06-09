extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var item_list = $ItemList
onready var email : LineEdit = $ItemList/LineEdit


func _ready() -> void:
	set_profile()

func set_profile():
	item_list.remove_item(3)
	item_list.remove_item(3)
	item_list.set_item_text(0, "Nome: " + PlayerData.name_user)
	item_list.set_item_text(1, "Cognome: " + PlayerData.surname_user)
	item_list.set_item_text(2, "Email: " + PlayerData.email)
	item_list.set_item_text(3, "Codice medico: " + PlayerData.medic_code)



func _on_BackButton_pressed():
	get_tree().change_scene("res://src/screens/MenuScreen.tscn")
