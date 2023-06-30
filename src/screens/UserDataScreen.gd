extends Control

onready var http : HTTPRequest = $HTTPRequest

onready var name_patient : LineEdit = $HBoxContainer/Name
onready var surname_patient : LineEdit = $HBoxContainer/Surname

onready var games : Label = $HBoxContainer1/Games_1
onready var high : Label = $HBoxContainer3/High_1
onready var count_mode_1 : LineEdit = $HBoxContainer2/Games_1
onready var high_mode_1 : LineEdit = $HBoxContainer4/High_1

onready var dec_avg : LineEdit = $HBoxContainer2/dec_avg
onready var breath_duration : LineEdit = $HBoxContainer4/Breath
onready var score : LineEdit = $HBoxContainer6/Score
onready var game_duration : LineEdit = $HBoxContainer6/Duration


func _ready():
	PlayerData.get_flag = 1
	Firebase.get_document("patients/%s" % PlayerData.patients[PlayerData.user_flag], http)
	yield(get_tree().create_timer(1.0), "timeout")
	PlayerData.get_flag = 2
	if(PlayerData.first_mode == true):
		Firebase.get_document("patients/%s/games_first_mode" % PlayerData.patients[PlayerData.user_flag], http)
	elif(PlayerData.second_mode == true):
		Firebase.get_document("patients/%s/games_second_mode" % PlayerData.patients[PlayerData.user_flag], http)
	elif(PlayerData.third_mode == true):
		Firebase.get_document("patients/%s/games_third_mode" % PlayerData.patients[PlayerData.user_flag], http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	if(PlayerData.get_flag == 2):
		dec_avg.text = str(result_body.documents[PlayerData.game_flag].fields.decibel_avg.doubleValue) + " db"
		breath_duration.text = result_body.documents[PlayerData.game_flag].fields.breath_duration.stringValue
		score.text = str(result_body.documents[PlayerData.game_flag].fields.score.integerValue) + " pnt"
		game_duration.text = result_body.documents[PlayerData.game_flag].fields.game_duration.stringValue
	elif(PlayerData.get_flag == 1):
		if(PlayerData.first_mode == true):
			games.text = "Partite giocate livello BOLLE" 
			high.text = "Miglior punteggio livello BOLLE"
			count_mode_1.text = str(result_body.fields.games_first_mode_count.integerValue)
			high_mode_1.text = str(result_body.fields.highscore_first_mode.integerValue) + " pnt"
		elif(PlayerData.second_mode == true):
			games.text = "Partite giocate livello RUNNER"
			high.text = "Miglior punteggio livello RUNNER" 
			count_mode_1.text = str(result_body.fields.games_second_mode_count.integerValue)
			high_mode_1.text = str(result_body.fields.highscore_second_mode.integerValue) + " pnt"
		elif(PlayerData.third_mode == true):
			games.text = "Partite giocate livello BERSAGLI"
			high.text = "Miglior punteggio livello BERSAGLI" 
			count_mode_1.text = str(result_body.fields.games_third_mode_count.integerValue)
			high_mode_1.text = str(result_body.fields.highscore_third_mode.integerValue) + " pnt"
		name_patient.text = result_body.fields.name.stringValue
		surname_patient.text = result_body.fields.surname.stringValue


func _on_Button_pressed():
	PlayerData.get_flag = 0
	get_tree().change_scene("res://src/screens/Games.tscn")

func _on_Quit_pressed():
	get_tree().quit()
