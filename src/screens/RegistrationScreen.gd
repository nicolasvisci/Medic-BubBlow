extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var name_field: LineEdit = $Menu1/NameField
onready var surname_field: LineEdit = $Menu1/SurnameField
onready var email_field : LineEdit = $Menu1/MailField
onready var password_field : LineEdit = $Menu1/PasswordField
onready var medicCode_field : LineEdit = $Menu1/MedicCodeField
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification

var flag = 0
var timer = Timer.new()
var hide_delay = 4
var profile := {
	"name": {},
	"surname": {},
	"email": {},
	"medic_code": {}
} 

func _ready():
	set_timer()

func set_timer():
	add_child(timer)
	timer.set_wait_time(hide_delay)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "hide_label")

func _on_RegisterButton_pressed() -> void:
	if name_field.text.empty():
		notification.text = "Inserisci nome"
		show_label()
		return
	if surname_field.text.empty():
		notification.text = "Inserisci cognome"
		show_label()
		return
	if email_field.text.empty():
		notification.text = "Inserisci email"
		show_label()
		return
	if password_field.text.empty():
		notification.text = "Inserisci password"
		show_label()
		return
	if medicCode_field.text.empty():
		notification.text = "Inserisci codice medico"
		show_label()
		return
	elif medicCode_field.text == "12345678":
		PlayerData.name_user = name_field.text
		PlayerData.surname_user = surname_field.text
		PlayerData.email = email_field.text
		PlayerData.medic_code = medicCode_field.text
		Firebase.register(email_field.text, password_field.text, http)
		yield(get_tree().create_timer(3.5), "timeout")
		profile.name = {"stringValue": PlayerData.name_user}
		profile.surname = {"stringValue": PlayerData.surname_user}
		profile.email = { "stringValue": PlayerData.email}
		profile.medic_code = {"stringValue": PlayerData.medic_code}
		Firebase.save_document("medics?documentId=%s" % Firebase.user_info.id, profile, http)
		notification.text = "Registrazione avvenuta con successo"
		show_label()
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://src/screens/MenuScreen.tscn")
		
	else:
		notification.text = "Codice Medico errato riprovare!"
		show_label()
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://src/screens/RegistrationScreen.tscn")
		
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://src/screens/MedicCodeScreen.tscn")

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200 && flag == 0:
		notification.text = response_body.result.error.message.capitalize()
		show_label()
	elif flag == 0:
		notification.text = "Registrazione in corso..."
		show_label()
		flag = 1

func show_label():
	notification_panel.show()
	timer.start()

func hide_label():
	notification_panel.hide()


func _on_AlreadyRegisteredButton_pressed():
	get_tree().change_scene("res://src/screens/LoginScreen.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
