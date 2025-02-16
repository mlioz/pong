extends ColorRect

@onready var screen_size: Vector2 = get_viewport().size

func _draw() -> void:
	draw_line(Vector2(screen_size.x / 2, 0), Vector2(screen_size.x / 2, screen_size.y), Color.WHITE, 5.0)
