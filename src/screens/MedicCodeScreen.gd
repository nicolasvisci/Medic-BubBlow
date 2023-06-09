extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var medic_code : LineEdit = $Menu/MedicCodeField
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification
onready var send_button : Button = $Menu/SendButton

var information_sent := false
var profile := {
	"name": {},
	"surname": {},
	"email": {},
	"medic_code": {}
} 

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
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
		PlayerData.medic_code = medic_code.text
		profile.name = {"stringValue": PlayerData.name_user}
		profile.surname = {"stringValue": PlayerData.surname_user}
		profile.email = { "stringValue": PlayerData.email}
		profile.medic_code = {"stringValue": PlayerData.medic_code}
		Firebase.save_document("medics?documentId=%s" % Firebase.user_info.id, profile, http)
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
