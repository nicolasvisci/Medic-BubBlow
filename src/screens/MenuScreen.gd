extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var dynamic_button = $Menu/DynamicButton
onready var leaderboard_button = $LeaderboardButton


func _ready():
	Firebase.get_document("patients", http)

func _on_DatiPazientiButton_pressed():
	get_tree().change_scene("res://src/screens/PeopleScreen.tscn")


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
	var link = result_body.documents[1].name
	var uid = link.split("/")
	var uid_patient = uid[6] # Preleva uid paziente
	PlayerData.patient_id_2 = uid_patient
	#print(PlayerData.patient_id_2)  Stampa uid paziente
