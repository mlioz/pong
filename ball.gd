extends RigidBody2D

@onready var screen_size: Vector2 = get_viewport().size

@export var speed: int = 200
@export var color: Color = Color.WHITE

var velocity: Vector2 = Vector2(-speed, speed)
var reset_pos: bool = false

signal ball_position(pos: Vector2)
signal ball_exited

func _draw() -> void:
	draw_rect(Rect2(-8, -8, 16, 16), color, true)
	
func _process(delta: float) -> void:
	var info = move_and_collide(velocity * delta)
	
	if info:
		velocity = velocity.bounce(info.get_normal())

func _physics_process(_delta: float) -> void:
	ball_position.emit(position)

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if reset_pos:
		position = screen_size / 2
		reset_pos = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	ball_exited.emit()

func start() -> void:
	speed = 200
	reset_pos = true
