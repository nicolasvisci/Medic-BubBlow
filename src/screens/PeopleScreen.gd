extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var name_patient_1 : LineEdit = $HBoxContainer2/LineEdit
onready var surname_patient_1 : LineEdit = $HBoxContainer2/LineEdit2
onready var name_patient_2 : LineEdit = $HBoxContainer3/LineEdit
onready var surname_patient_2 : LineEdit = $HBoxContainer3/LineEdit2
onready var name_patient_3 : LineEdit = $HBoxContainer4/LineEdit
onready var surname_patient_3 : LineEdit = $HBoxContainer4/LineEdit2
var count := 1

func _ready():
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
	PlayerData.user_flag = 1
	get_tree().change_scene("res://src/screens/UserDataScreen.tscn")


func _on_Button2_pressed():
	PlayerData.user_flag = 2
	get_tree().change_scene("res://src/screens/UserDataScreen.tscn")
	
func _on_Button3_pressed():
	PlayerData.user_flag = 3
	get_tree().change_scene("res://src/screens/UserDataScreen.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
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
	get_tree().change_scene("res://src/screens/MenuScreen.tscn")
