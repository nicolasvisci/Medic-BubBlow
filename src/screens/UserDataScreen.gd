extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var name_patient : LineEdit = $Name
onready var surname_patient : LineEdit = $Surname
onready var games : Label = $HBoxContainer1/Games_1
onready var high : Label = $HBoxContainer3/High_1
onready var count_mode_1 : LineEdit = $HBoxContainer2/Games_1
onready var count_mode_2 : LineEdit = $HBoxContainer2/Games_2
onready var dec_avg : LineEdit = $HBoxContainer2/dec_avg
onready var high_mode_1 : LineEdit = $HBoxContainer4/High_1
onready var high_mode_2 : LineEdit = $HBoxContainer4/High_2
onready var breath_duration : LineEdit = $HBoxContainer4/Breath
onready var score : LineEdit = $HBoxContainer6/Score
onready var game_duration : LineEdit = $HBoxContainer6/Duration


func _ready():
	if(PlayerData.user_flag == 1):
		PlayerData.get_flag = 1
		Firebase.get_document("patients/%s" % PlayerData.patient_id_1, http)
		yield(get_tree().create_timer(1.0), "timeout")
		PlayerData.get_flag = 2
		if(PlayerData.first_mode == true):
			#type.text = "Partite giocate modalita 1" 
			Firebase.get_document("patients/%s/games_first_mode" % PlayerData.patient_id_1, http)
		elif(PlayerData.second_mode == true):
			Firebase.get_document("patients/%s/games_second_mode" % PlayerData.patient_id_1, http)
	elif(PlayerData.user_flag == 2):
		PlayerData.get_flag = 1
		Firebase.get_document("patients/%s" % PlayerData.patient_id_2, http)
		yield(get_tree().create_timer(1.0), "timeout")
		PlayerData.get_flag = 2
		if(PlayerData.first_mode == true):
			Firebase.get_document("patients/%s/games_first_mode" % PlayerData.patient_id_2, http)
		elif(PlayerData.second_mode == true):
			Firebase.get_document("patients/%s/games_second_mode" % PlayerData.patient_id_2, http)
	elif(PlayerData.user_flag == 3):
		PlayerData.get_flag = 1
		Firebase.get_document("patients/%s" % PlayerData.patient_id_3, http)
		yield(get_tree().create_timer(1.0), "timeout")
		PlayerData.get_flag = 2
		if(PlayerData.first_mode == true):
			Firebase.get_document("patients/%s/games_first_mode" % PlayerData.patient_id_3, http)
			PlayerData.first_mode = false
		elif(PlayerData.second_mode == true):
			Firebase.get_document("patients/%s/games_second_mode" % PlayerData.patient_id_3, http)
			PlayerData.second_mode = false
		#yield(get_tree().create_timer(1.0), "timeout")
	

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	if(PlayerData.get_flag == 2):
		#print(count_mode_2.text)
		#var partite = result_body.documents.size()
		#print(result_body.documents.size())
		#for n in range(0,partite):
			#print(result_body.documents[n]) #Dati partita
			#print(" ")
		dec_avg.text = str(result_body.documents[0].fields.decibel_avg.doubleValue) + " db"
		breath_duration.text = result_body.documents[0].fields.breath_duration.stringValue
		score.text = str(result_body.documents[0].fields.score.integerValue) + " pnt"
		game_duration.text = result_body.documents[0].fields.game_duration.stringValue
	elif(PlayerData.get_flag == 1):
		if(PlayerData.first_mode == true):
			games.text = "Partite giocate modalita 1" 
			high.text = "Miglior punteggio modalita 1"
			count_mode_1.text = str(result_body.fields.games_first_mode_count.integerValue)
			high_mode_1.text = str(result_body.fields.highscore_first_mode.integerValue) + " pnt"
		elif(PlayerData.second_mode == true):
			games.text = "Partite giocate modalita 2"
			high.text = "Miglior punteggio modalita 2" 
			count_mode_1.text = str(result_body.fields.games_second_mode_count.integerValue)
			high_mode_1.text = str(result_body.fields.highscore_second_mode.integerValue) + " pnt"
		name_patient.text = result_body.fields.name.stringValue
		surname_patient.text = result_body.fields.surname.stringValue
		
		


func _on_Button_pressed():
	reset_flag()
	get_tree().change_scene("res://src/screens/PeopleScreen.tscn")

func reset_flag():
	PlayerData.get_flag = 0
	PlayerData.first_mode = false
	PlayerData.second_mode = false
	PlayerData.third_mode = false
