extends Node2D

@onready var screen_size: Vector2 = get_viewport().size
@onready var ui_player_score = $UI/Score/MarginContainer/VBoxContainer/HBoxContainer/PlayerScore
@onready var ui_ai_score = $UI/Score/MarginContainer/VBoxContainer/HBoxContainer/AIScore
@onready var ui_play_button: Button = $UI/MainMenu/MarginContainer/VBoxContainer/Start
@onready var ui_quit_button: Button = $UI/MainMenu/MarginContainer/VBoxContainer/Quit

var score_player: int = 0
var score_ai: int = 0

func _ready() -> void:
	ui_play_button.pressed.connect(start_game)

	$Player.center_paddle_position()
	$Ball.center_ball()
	$AI.center_paddle_position()
	
	pause()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		ui_play_button.text = "Resume"
		pause()

func start_game() -> void:
	ui_play_button.text = "Start Game"
	unpause()
	
func game_over() -> void:
	if $Ball.position.x < 0:
		score_ai += 1
		ui_ai_score.text = str(score_ai)
	else:
		score_player += 1
		ui_player_score.text = str(score_player)
	
	$Player.center_paddle_position()
	$AI.center_paddle_position()
	$Ball.center_ball()
	
	pause()

func pause() -> void:
	get_tree().paused = true
	$UI/MainMenu.show()

func unpause() -> void:
	get_tree().paused = false
	$UI/MainMenu.hide()
