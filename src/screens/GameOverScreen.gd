extends Control

onready var score_text : Label = $MenuContainer/Menu1/ScoreText
onready var score_number: Label = $MenuContainer/Menu1/ScoreNumber
onready var text_animations : AnimationPlayer = $TextAnimations

func _ready():
	check_music()
	set_score()

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game_over.wav")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()

func set_score():
	yield(get_tree().create_timer(1.0),"timeout")
	score_text.text = "PUNTEGGIO: "
	score_number.text= "%s" % PlayerData.score
	text_animations.play("show_score_text")
