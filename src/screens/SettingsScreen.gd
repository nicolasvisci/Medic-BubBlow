extends Control

onready var menu: VBoxContainer = $Menu
onready var music_button: CheckBox = get_node("Menu/MusicButton")
onready var effects_button: CheckBox = get_node("Menu/EffectsButton")



func _ready():
	check_user_type()


func check_user_type():
	if PlayerData.user_type == "medic":
		music_button.visible = false
		menu.rect_size.y = 400
		
