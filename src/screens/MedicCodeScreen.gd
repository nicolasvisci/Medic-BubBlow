extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var medic_code : LineEdit = $Menu/MedicCodeField
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification
onready var send_button : Button = $Menu/SendButton

var email = ""
var information_sent := false
var profile := {
	"name": {},
	"surname": {},
	"email": {},
	"type_user": {},
	"medic_code": {}
} 

func _ready():
	Firebase.get_document("medics/%s" % Firebase.user_info.id, http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	email = result_body.fields.email.stringValue
	PlayerData.name_user = result_body.fields.name.stringValue
	PlayerData.surname_user = result_body.fields.surname.stringValue
	match response_code:
		404:
			notification.text = "Codice non valido."
			show_label()
			return
		200:
			if information_sent:
				notification.text = "Registrazione avvenuta con successo"
				show_label()
				information_sent = false

func _on_SendButton_pressed():
	if medic_code.text.empty():
		notification.text = "Inserisci il codice corretto"
		show_label()
		return
	if medic_code.text == "12345678":
		PlayerData.user_type = "medic"
		PlayerData.email = email
		PlayerData.medic_code = medic_code.text
		profile.name = {"stringValue": PlayerData.name_user}
		profile.surname = {"stringValue": PlayerData.surname_user}
		profile.type_user = { "stringValue": "medic" }
		profile.email = { "stringValue": email}
		profile.medic_code = {"stringValue": medic_code.text}
		Firebase.update_document("medics/%s" % Firebase.user_info.id, profile, http)
		information_sent = true
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://src/screens/MenuScreen.tscn")
	else:
		notification.text = "Il codice inserito non e' valido"
		show_label()
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://src/screens/RegistrationScreen.tscn")
		return

func show_label():
	notification_panel.show()


func _on_BackButton_pressed():
	get_tree().change_scene("res://src/screens/RegistrationScreen.tscn")
