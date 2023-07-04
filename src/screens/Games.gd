extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var leaderboard_scroll1 : ScrollContainer = $ScrollContainer # Intestazione tabella
onready var leaderboard_patient_text : Label = $ScrollContainer/HBoxContainer/VBoxContainer2/Dati # Label DATI
onready var leaderboard_scroll2 : ScrollContainer = $ScrollContainer2 # Corpo tabella
onready var leaderboard_name_container1: VBoxContainer = $ScrollContainer2/HBoxContainer/VBoxContainer # Sezione nomi e cognomi
onready var leaderboard_patient_container1: VBoxContainer = $ScrollContainer2/HBoxContainer/VBoxContainer2 # Sezione bottoni DETTAGLI
onready var hboxcontainer: HBoxContainer = $ScrollContainer2/HBoxContainer/VBoxContainer2/HBoxContainer # Sezione bottoni DETTAGLI
onready var campo1: VBoxContainer = $ScrollContainer2/HBoxContainer/VBoxContainer2/HBoxContainer/campo1 # Sezione bottoni DETTAGLI
onready var campo2: VBoxContainer = $ScrollContainer2/HBoxContainer/VBoxContainer2/HBoxContainer/campo2 # Sezione bottoni DETTAGLI
onready var campo3: VBoxContainer = $ScrollContainer2/HBoxContainer/VBoxContainer2/HBoxContainer/campo3 # Sezione bottoni DETTAGLI
onready var button: VBoxContainer = $ScrollContainer2/HBoxContainer/VBoxContainer2/HBoxContainer/button

var leaderboard_text = preload("res://src/user interface/LeaderboardText.tscn")
var campoPartita1_text = preload("res://src/user interface/CampoPartita.tscn")
var campoPartita2_text = preload("res://src/user interface/CampoPartita.tscn")
var campoPartita3_text = preload("res://src/user interface/CampoPartita.tscn")
var leaderboard_details_button_1 = preload("res://src/user interface/DetailsButton2.tscn")

var count_button := 0 # Bottoni Dettagli istanziati
var count_game := 0 # Partite presenti nel database

var name_patient = "" # Nome paziente in tabella
var surname_patient = "" # Cognome paziente in tabella
var documents # Lista di tutti i pazienti

var game_duration
var breath_duration_max
var score
#var decibel_avg

func _ready():
	PlayerData.games.resize(50)
	remove_leaderboard_scrollbar()
	if(PlayerData.first_mode == true):
		Firebase.get_document("patients/%s/games_first_mode" % PlayerData.patients[PlayerData.user_flag], http)
	elif(PlayerData.second_mode == true):
		Firebase.get_document("patients/%s/games_second_mode" % PlayerData.patients[PlayerData.user_flag], http)
	elif(PlayerData.third_mode == true):
		Firebase.get_document("patients/%s/games_third_mode" % PlayerData.patients[PlayerData.user_flag], http)
	yield(get_tree().create_timer(2.0), "timeout")

func remove_leaderboard_scrollbar():
	leaderboard_scroll1.get_h_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll1.get_v_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll2.get_h_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll2.get_v_scrollbar().modulate = Color(0,0,0,0)


func populate_leaderboard_names():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = "Partita " + str(count_game)
	leaderboard_name_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = "Partita " + str(count_game)

func populate_leaderboard_buttons():
	leaderboard_patient_text.text = "DURATA PARTITA - DURATA RESPIRO MAX - PUNTI PARTITA"
	var leaderboard_details_button_instance_1 = leaderboard_details_button_1.instance()
	var campoPartita_instance_1 = campoPartita1_text.instance()
	var campoPartita_instance_2 = campoPartita2_text.instance()
	var campoPartita_instance_3 = campoPartita3_text.instance()
	
	campoPartita_instance_1.add_color_override("font_color", Color(255,255,255,255))
	campoPartita_instance_1.text = game_duration
	campo1.add_child(campoPartita_instance_1)
	
	campoPartita_instance_2.add_color_override("font_color", Color(255,255,255,255))
	campoPartita_instance_2.text = breath_duration_max
	campo2.add_child(campoPartita_instance_2)
	
	campoPartita_instance_3.add_color_override("font_color", Color(255,255,255,255))
	#campoPartita_instance_3.text = decibel_avg + " db"
	campoPartita_instance_3.text = score + " pnt"
	campo3.add_child(campoPartita_instance_3)
	
	button.add_child(leaderboard_details_button_instance_1)
	
	count_button += 1
	leaderboard_details_button_instance_1.set_user(count_button)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	documents = result_body["documents"]
	for doc in documents:
		count_game += 1
		var documentData = doc["fields"]
		game_duration = documentData.game_duration.stringValue
		breath_duration_max = documentData.breath_duration.stringValue
		score = documentData.score.integerValue
		#decibel_avg = str(80 - int(documentData.decibel_avg.doubleValue) * -1)
		var documentId = doc["name"]
		var uid = documentId.split("/")
		var uid_game = uid[8]
		PlayerData.games[count_game] = uid_game
		populate_leaderboard_names()
		populate_leaderboard_buttons()

func reset_flag():
	PlayerData.first_mode = false
	PlayerData.second_mode = false
	PlayerData.third_mode = false

func _on_Button_pressed():
	reset_flag()
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://src/screens/TableScreen.tscn")


func _on_Button2_pressed():
	get_tree().quit()
