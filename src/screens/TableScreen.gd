extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var leaderboard_scroll1 : ScrollContainer = $ScrollContainer # Intestazione tabella
onready var leaderboard_score_text : Label = $ScrollContainer/HBoxContainer/VBoxContainer2/Cognome # Label DATI
onready var leaderboard_scroll2 : ScrollContainer = $ScrollContainer2 # Corpo tabella
onready var leaderboard_name_container1: VBoxContainer = $ScrollContainer2/HBoxContainer/VBoxContainer # Sezione nomi e cognomi

onready var leaderboard_score_container1: VBoxContainer = $ScrollContainer2/HBoxContainer/VBoxContainer2 # Sezione bottoni DETTAGLI

onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification

var leaderboard_text = preload("res://src/user interface/LeaderboardText.tscn")
var leaderboard_details_button_1 = preload("res://src/user interface/DetailsButton1.tscn")


var timer = Timer.new()
var hide_delay = 2

var name_user = ""
var surname_user = ""

var count := 0
var count_patient := 0

var documents

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
	leaderboard_text_instance.text = str(name_user) + " " + str(surname_user)
	leaderboard_name_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = str(name_user) + " " + str(surname_user)

func populate_leaderboard_buttons():
	leaderboard_score_text.text = "DATI"
	var leaderboard_details_button_instance_1 = leaderboard_details_button_1.instance()
	leaderboard_score_container1.add_child(leaderboard_details_button_instance_1)
	count += 1
	leaderboard_details_button_instance_1.set_user(count)

func _on_Button_pressed():
	get_tree().quit()


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
		name_user = documentData["name"].stringValue
		surname_user = documentData["surname"].stringValue
		var highscore_first_mode = documentData["highscore_first_mode"].integerValue
		var highscore_second_mode = documentData["highscore_second_mode"].integerValue
		populate_leaderboard_names()
		populate_leaderboard_buttons()


func _on_Button31_pressed():
	PlayerData.first_mode = true

func _on_Button32_pressed():
	PlayerData.second_mode = true
	
func _on_Button33_pressed():
	PlayerData.third_mode = true

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
