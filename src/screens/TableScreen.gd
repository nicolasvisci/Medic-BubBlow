extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var leaderboard_scroll1 : ScrollContainer = $ScrollContainer # Intestazione tabella
onready var leaderboard_patient_text : Label = $ScrollContainer/HBoxContainer/VBoxContainer2/Dati # Label DATI
onready var leaderboard_scroll2 : ScrollContainer = $ScrollContainer2 # Corpo tabella
onready var leaderboard_name_container1: VBoxContainer = $ScrollContainer2/HBoxContainer/VBoxContainer # Sezione nomi e cognomi
onready var leaderboard_patient_container1: VBoxContainer = $ScrollContainer2/HBoxContainer/VBoxContainer2 # Sezione bottoni DETTAGLI

onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification
var timer = Timer.new()
var hide_delay = 2

var leaderboard_text = preload("res://src/user interface/LeaderboardText.tscn")
var leaderboard_details_button_1 = preload("res://src/user interface/DetailsButton1.tscn")

var name_patient = "" # Nome paziente in tabella
var surname_patient = "" # Cognome paziente in tabella

var count_button := 0 # Bottoni Dettagli istanziati
var count_patient := 0 # Pazienti presenti nel database

var documents # Lista di tutti i pazienti

func _ready():
	PlayerData.patients.resize(50)
	set_timer()
	remove_leaderboard_scrollbar()
	Firebase.get_document("patients", http)
	yield(get_tree().create_timer(2.0), "timeout")

func remove_leaderboard_scrollbar():
	leaderboard_scroll1.get_h_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll1.get_v_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll2.get_h_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll2.get_v_scrollbar().modulate = Color(0,0,0,0)


func populate_leaderboard_names():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = str(name_patient) + " " + str(surname_patient)
	leaderboard_name_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = str(name_patient) + " " + str(surname_patient)

func populate_leaderboard_buttons():
	leaderboard_patient_text.text = "DATI"
	var leaderboard_details_button_instance_1 = leaderboard_details_button_1.instance()
	leaderboard_patient_container1.add_child(leaderboard_details_button_instance_1)
	count_button += 1
	leaderboard_details_button_instance_1.set_user(count_button)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body = JSON.parse(body.get_string_from_ascii()).result
	documents = result_body["documents"]
	for doc in documents:
		count_patient += 1
		var documentData = doc["fields"]
		var documentId = doc["name"]
		var uid = documentId.split("/")
		var uid_patient = uid[6]
		PlayerData.patients[count_patient] = uid_patient
		name_patient = documentData["name"].stringValue
		surname_patient = documentData["surname"].stringValue
		populate_leaderboard_names()
		populate_leaderboard_buttons()


func _on_ButtonFirstMode_pressed():
	PlayerData.first_mode = true

func _on_ButtonSecondMode_pressed():
	PlayerData.second_mode = true
	
func _on_ButtonThirdMode_pressed():
	PlayerData.third_mode = true

func _on_Button_pressed():
	get_tree().quit()

func set_timer():
	add_child(timer)
	timer.set_wait_time(hide_delay)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "hide_label")

func show_label():
	notification_panel.show()
	timer.start()

func hide_label():
	notification_panel.hide()


func _on_Back_pressed():
	get_tree().change_scene("res://src/screens/MenuScreen.tscn")


func _on_Quit_pressed():
	get_tree().quit()
