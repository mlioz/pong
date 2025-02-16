extends RigidBody2D

@export var speed: int = 200
@export var color: Color = Color.WHITE

var velocity: Vector2 = Vector2(-speed, speed)

signal ball_position(pos: Vector2)
signal ball_exited

func _draw() -> void:
	draw_rect(Rect2(-8, -8, 16, 16), color, true)
	
func _process(delta: float) -> void:
	var info = move_and_collide(velocity * delta)
	
	if info:
		velocity = velocity.bounce(info.get_normal())

func _physics_process(delta: float) -> void:
	ball_position.emit(position)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	ball_exited.emit()
