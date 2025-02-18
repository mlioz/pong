extends Node2D

@onready var screen_size: Vector2 = get_viewport().size
@onready var ui_player_score = $UI/MarginContainer/VBoxContainer/HBoxContainer/PlayerScore
@onready var ui_ai_score = $UI/MarginContainer/VBoxContainer/HBoxContainer/AIScore

var score_player: int = 0
var score_ai: int = 0

func _ready() -> void:
	start_game()

func start_game() -> void:
	$Player.position.x = 20
	$Player.position.y = screen_size.y / 2
	
	$AI.position.x = screen_size.x - 25
	$AI.position.y = screen_size.y / 2
	
	$Ball.start()

func game_over() -> void:
	if $Ball.position.x < 0:
		score_ai += 1
		ui_ai_score.text = str(score_ai)
	else:
		score_player += 1
		ui_player_score.text = str(score_player)
		
	print("Game Over. Player score: %s, AI score: %s" % [score_player, score_ai])
	start_game()

func _on_timer_timeout() -> void:
	$Ball.speed += 50

func _on_ball_body_entered(body: Node) -> void:
	print("Contact with %s" % body.name)
