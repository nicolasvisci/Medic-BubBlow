extends Control

onready var http : HTTPRequest = $HTTPRequest


func _ready():
	Firebase.get_document("patients", http)

func _on_DatiPazientiButton_pressed():
	get_tree().change_scene("res://src/screens/TableScreen.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_CreditsButton_pressed():
	get_tree().change_scene("res://src/screens/CreditsScreen.tscn")


func _on_LogoutButton_pressed():
	get_tree().change_scene("res://src/screens/RegistrationScreen.tscn")


func _on_ProfileButton_pressed():
	get_tree().change_scene("res://src/screens/ProfileScreen.tscn")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
