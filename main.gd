extends Node2D

@onready var screen_size: Vector2i = get_viewport().size

@onready var ui_player_score = $UI/Score/MarginContainer/VBoxContainer/HBoxContainer/PlayerScore
@onready var ui_opponent_score = $UI/Score/MarginContainer/VBoxContainer/HBoxContainer/OpponentScore

@onready var ui_play_button: Button = $UI/MainMenu/MarginContainer/VBoxContainer/Start
@onready var ui_quit_button: Button = $UI/MainMenu/MarginContainer/VBoxContainer/Quit

var player: Paddle
var opponent: Paddle

var score_player: int = 0
var score_ai: int = 0

func _ready() -> void:
	player = Paddle.new_paddle(Color.GREEN, Globals.ControlMethod.COMPUTER)
	opponent = Paddle.new_paddle(Color.RED, Globals.ControlMethod.COMPUTER)
	
	if opponent.control_method == Globals.ControlMethod.COMPUTER:
		$Ball.ball_bounced.connect(opponent.on_ball_bounce)
	
	if player.control_method == Globals.ControlMethod.COMPUTER:
		$Ball.ball_bounced.connect(player.on_ball_bounce)
	
	self.add_child(player)
	self.add_child(opponent)
	
	ui_play_button.pressed.connect(start_game)
	
	reset_game()
	pause()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		ui_play_button.text = "Resume"
		pause()

func start_game() -> void:
	ui_play_button.text = "Start Game"
	unpause()
	player.on_ball_bounce($Ball.position, $Ball.velocity)
	opponent.on_ball_bounce($Ball.position, $Ball.velocity)
	
func game_over() -> void:
	if $Ball.position.x < 0:
		score_ai += 1
		ui_opponent_score.text = str(score_ai)
	else:
		score_player += 1
		ui_player_score.text = str(score_player)
	
	reset_game()
	pause()

func pause() -> void:
	get_tree().paused = true
	$UI/MainMenu.show()

func unpause() -> void:
	get_tree().paused = false
	$UI/MainMenu.hide()

func reset_game():
	player.reset_position(20, int(screen_size.y / 2.0))
	opponent.reset_position(screen_size.x - 25, int(screen_size.y / 2.0))
	
	$Ball.reset()
