extends Node2D

@onready var screen_size: Vector2 = get_viewport().size

var score_player: int = 0
var score_ai: int = 0

func _ready() -> void:
	start_game()

func start_game() -> void:
	$Player.position.x = 20
	$Player.position.y = screen_size.y / 2
	
	$AI.position.x = screen_size.x - 20
	$AI.position.y = screen_size.y / 2
	
	$Ball.position = screen_size / 2
	#need to pause physics_process to move ball

func game_over() -> void:
	if $Ball.position.x < 0:
		score_ai += 1
	else:
		score_player += 1
		
	print("Game Over. Player score: %s, AI score: %s" % [score_player, score_ai])
	start_game()
