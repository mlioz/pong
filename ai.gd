extends Area2D

@onready var screen_size: Vector2 = get_viewport().size
@onready var new_position: Vector2

@export var speed: float = 500
@export var paddle_size: Vector2 = Vector2(16, 128)
@export var color: Color = Color.RED

var direction = 0

func _ready() -> void:
	center_paddle_position()
	new_position = position

func _draw():
	draw_rect(Rect2(paddle_size.x / 2 * -1, paddle_size.y / 2 * -1, paddle_size.x, paddle_size.y), color, true)

func center_paddle_position() -> void:
	position.x = screen_size.x - 25
	position.y = screen_size.y / 2

func _process(delta: float) -> void:
	position.y = move_toward(position.y, new_position.y, speed * delta)
	
	# Prevents the paddle from going off the screen
	position.y = clampf(position.y, paddle_size.y / 2, screen_size.y - paddle_size.y / 2)

func _on_ball_predicted_ball_bounce(y: int) -> void:
	new_position.y = y
	direction = (new_position.y - position.y)/abs(new_position.y - position.y)
