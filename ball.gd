extends Area2D

@onready var low_bounce_sound: AudioStreamPlayer = $LowBounceSound
@onready var high_bounce_sound: AudioStreamPlayer = $HighBounceSound

@onready var screen_size: Vector2 = get_viewport().size

@export var speed: int = 200
@export var speed_increase: int = 50
@export var color: Color = Color.WHITE

var initial_velocity: Vector2 = Vector2(-speed, speed)
var current_velocity: Vector2 = initial_velocity
var reset_pos: bool = false

signal predicted_ball_bounce(y: int)
signal ball_exited_screen

func _draw() -> void:
	draw_rect(Rect2(-8, -8, 16, 16), color, true)
	
func _process(delta: float) -> void:
	position += current_velocity * delta
	
	if position.y < 0 or position.y > screen_size.y:
		current_velocity.y = -current_velocity.y
		high_bounce_sound.play()
		check_and_emit_ball_bounce_position(position, current_velocity)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		current_velocity.x = abs(current_velocity.x - speed_increase)
		low_bounce_sound.play()
		check_and_emit_ball_bounce_position(position, current_velocity)
		
	elif area.name == "AI":
		current_velocity.x = -abs(current_velocity.x + speed_increase)
		low_bounce_sound.play()
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	ball_exited_screen.emit()

func center_ball() -> void:
	position = screen_size / 2
	current_velocity = initial_velocity

func check_and_emit_ball_bounce_position(ball_pos: Vector2, ball_vel: Vector2) -> void:
	if current_velocity.x > 0:
			var ball_y_bounce_predictions = get_preicted_ball_bounce(ball_pos, ball_vel)
			
			# AI shouldn't move if the ball's bounce y coordinate is not on screen
			if ball_y_bounce_predictions > 0:
				predicted_ball_bounce.emit(ball_y_bounce_predictions)

func get_preicted_ball_bounce(pos: Vector2, vel: Vector2) -> int:
	 #Use the parametric equation for the ball's path to find what y value it will bounce on the AI's wall
	 #pos = (posx, posy)
	 #vel = (velx, vely)
	 #x(t) = posx + velx*t
	 #y(t) = posy + vely*t
	 #t = (x - pox)/velx
	 #y = posy + vely/velx*(x-posx)
	
	var ai_paddle_x_pos = screen_size.x - 25
	var ball_y_bounce = pos.y + vel.y/vel.x * (ai_paddle_x_pos - pos.x)
	
	return ball_y_bounce
