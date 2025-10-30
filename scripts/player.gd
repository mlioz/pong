extends CharacterBody2D

@onready var screen_size: Vector2 = get_viewport().size

@export var speed: float = 500
@export var paddle_size: Vector2 = Vector2(16, 128)
@export var color: Color = Color.RED

func _draw():
	draw_rect(Rect2(paddle_size.x / 2 * -1, paddle_size.y / 2 * -1, paddle_size.x, paddle_size.y), color, true)

func _physics_process(delta: float) -> void:
	var axis = Input.get_axis("ui_up", "ui_down")
	
	position.y += axis * speed * delta
	
	# Prevents the paddle from going off the screen
	position.y = clampf(position.y, paddle_size.y / 2, screen_size.y - paddle_size.y / 2)
