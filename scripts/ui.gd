extends CanvasLayer

@onready var screen_size: Vector2 = get_viewport().size

func _on_quit_pressed() -> void:
	get_tree().quit()
