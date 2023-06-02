extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var dynamic_button = $Menu/DynamicButton
onready var leaderboard_button = $LeaderboardButton
	


func _on_DatiPazientiButton_pressed():
	get_tree().change_scene("res://src/screens/LeaderboardScreen.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
