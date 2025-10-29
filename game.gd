extends Node2D
class_name Game

const GAME: PackedScene = preload("res://game.tscn")

@onready var screen_size: Vector2i = get_viewport().size

@onready var ui_player_score: Label = $UI/Score/MarginContainer/VBoxContainer/HBoxContainer/PlayerScore
@onready var ui_opponent_score: Label = $UI/Score/MarginContainer/VBoxContainer/HBoxContainer/OpponentScore

@onready var ui_resume_button: Button = $UI/PauseMenu/MarginContainer/VBoxContainer/Resume
@onready var ui_quit_button: Button = $UI/PauseMenu/MarginContainer/VBoxContainer/Quit

var player: Paddle
var opponent: Paddle

var score_player: int = 0
var score_opponent: int = 0

func _ready() -> void:
	player = Paddle.new_paddle(Color.GREEN, Global.player_1_control_method)
	opponent = Paddle.new_paddle(Color.RED, Global.player_2_control_method)
	
	if opponent.control_method == Global.ControlMethod.COMPUTER:
		$Ball.ball_bounced.connect(opponent.on_ball_bounce)
	
	if player.control_method == Global.ControlMethod.COMPUTER:
		$Ball.ball_bounced.connect(player.on_ball_bounce)
	
	self.add_child(player)
	self.add_child(opponent)
	
	ui_resume_button.pressed.connect(start_game)
	
	reset_game()
	start_game()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause()

func start_game() -> void:
	unpause()
	player.on_ball_bounce($Ball.position, $Ball.velocity)
	opponent.on_ball_bounce($Ball.position, $Ball.velocity)
	
func game_over() -> void:
	if $Ball.position.x < 0:
		score_opponent += 1
		ui_opponent_score.text = str(score_opponent)
	else:
		score_player += 1
		ui_player_score.text = str(score_player)
	
	reset_game()
	pause()

func pause() -> void:
	get_tree().paused = true
	$UI/PauseMenu.show()

func unpause() -> void:
	get_tree().paused = false
	$UI/PauseMenu.hide()

func reset_game():
	player.reset_position(20, int(screen_size.y / 2.0))
	opponent.reset_position(screen_size.x - 25, int(screen_size.y / 2.0))
	
	$Ball.reset()
