extends Area2D

@onready var screen_size: Vector2 = get_viewport().size

@export var speed: int = 200
@export var color: Color = Color.WHITE

var initial_velocity: Vector2 = Vector2(-speed, speed)
var current_velocity: Vector2 = initial_velocity
var reset_pos: bool = false

signal ball_position(pos: Vector2)
signal ball_exited_screen

func _draw() -> void:
	draw_rect(Rect2(-8, -8, 16, 16), color, true)
	
func _process(delta: float) -> void:
	if reset_pos == true:
		position = screen_size / 2
		current_velocity = initial_velocity
		reset_pos = false
	else:
		position += current_velocity * delta
	
		if position.y < 0 or position.y > screen_size.y:
			current_velocity.y = -current_velocity.y
		
		ball_position.emit(position)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		current_velocity.x = abs(current_velocity.x)
	elif area.name == "AI":
		current_velocity.x = -abs(current_velocity.x)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	ball_exited_screen.emit()

func start() -> void:
	speed = 200
	reset_pos = true
