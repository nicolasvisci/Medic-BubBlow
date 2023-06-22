extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var name_patient_1 : LineEdit = $HBoxContainer2/LineEdit
onready var surname_patient_1 : LineEdit = $HBoxContainer2/LineEdit2
onready var name_patient_2 : LineEdit = $HBoxContainer3/LineEdit
onready var surname_patient_2 : LineEdit = $HBoxContainer3/LineEdit2
onready var name_patient_3 : LineEdit = $HBoxContainer4/LineEdit
onready var surname_patient_3 : LineEdit = $HBoxContainer4/LineEdit2
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification
var count := 0

var timer = Timer.new()
var hide_delay = 2

func _ready():
	set_timer()
	for n in range(1,4):
		count = n
		if(n == 1):
			Firebase.get_document("patients/%s" % PlayerData.patient_id_1, http)
			yield(get_tree().create_timer(1.0), "timeout")
		if(n == 2):
			Firebase.get_document("patients/%s" % PlayerData.patient_id_2, http)
			yield(get_tree().create_timer(1.0), "timeout")
		if(n == 3):
			Firebase.get_document("patients/%s" % PlayerData.patient_id_3, http)
			yield(get_tree().create_timer(1.0), "timeout")

func _on_Button1_pressed():
	if(PlayerData.first_mode == true || PlayerData.second_mode == true):
		PlayerData.user_flag = 1
		get_tree().change_scene("res://src/screens/UserDataScreen.tscn")
	else:
		notification.text = "SELEZIONARE UNA MODALITA'"
		show_label()


func _on_Button2_pressed():
	if(PlayerData.first_mode == true || PlayerData.second_mode == true):
		PlayerData.user_flag = 2
		get_tree().change_scene("res://src/screens/UserDataScreen.tscn")
	else:
		notification.text = "SELEZIONARE UNA MODALITA'"
		show_label()
	
func _on_Button3_pressed():
	if(PlayerData.first_mode == true || PlayerData.second_mode == true):
		PlayerData.user_flag = 3
		get_tree().change_scene("res://src/screens/UserDataScreen.tscn")
	else:
		notification.text = "SELEZIONARE UNA MODALITA'"
		show_label()

func _on_Button31_pressed():
	#PlayerData.user_flag = 3
	PlayerData.first_mode = true
	#get_tree().change_scene("res://src/screens/UserDataScreen.tscn")

func _on_Button32_pressed():
	#PlayerData.user_flag = 3
	PlayerData.second_mode = true
	#get_tree().change_scene("res://src/screens/UserDataScreen.tscn")
	
func _on_Button33_pressed():
	PlayerData.third_mode = true


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	#print(result_body.documents[1].name)
	if(count == 1):
		name_patient_1.text = result_body.fields.name.stringValue
		surname_patient_1.text = result_body.fields.surname.stringValue
		PlayerData.name_user = result_body.fields.name.stringValue
		PlayerData.surname_user = result_body.fields.surname.stringValue
	if(count == 2):
		name_patient_2.text = result_body.fields.name.stringValue
		surname_patient_2.text = result_body.fields.surname.stringValue
		PlayerData.name_user = result_body.fields.name.stringValue
		PlayerData.surname_user = result_body.fields.surname.stringValue
	if(count == 3):
		name_patient_3.text = result_body.fields.name.stringValue
		surname_patient_3.text = result_body.fields.surname.stringValue
		PlayerData.name_user = result_body.fields.name.stringValue
		PlayerData.surname_user = result_body.fields.surname.stringValue


func _on_Back_pressed():
	reset_flag()
	get_tree().change_scene("res://src/screens/MenuScreen.tscn")


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

func reset_flag():
	PlayerData.first_mode = false
	PlayerData.second_mode = false
	PlayerData.third_mode = false