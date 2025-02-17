extends StaticBody2D

@onready var screen_size: Vector2 = get_viewport().size

@export var speed: float = 500
@export var paddle_size: Vector2 = Vector2(16, 128)
@export var color: Color = Color.RED

var ball_position: Vector2 = screen_size / 2

func _draw():
	draw_rect(Rect2(paddle_size.x / 2 * -1, paddle_size.y / 2 * -1, paddle_size.x, paddle_size.y), color, true)

func _process(delta: float) -> void:
	position.y += position.direction_to(ball_position).normalized().y * speed * delta
	
	# Prevents the paddle from going off the screen
	position.y = clampf(position.y, paddle_size.y / 2, screen_size.y - paddle_size.y / 2)

func _on_ball_ball_position(pos: Vector2) -> void:
	ball_position = pos
