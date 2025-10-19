extends CharacterBody2D

@onready var low_bounce_sound: AudioStreamPlayer = $LowBounceSound
@onready var high_bounce_sound: AudioStreamPlayer = $HighBounceSound

@onready var screen_size: Vector2 = get_viewport().size

@export var ball_size: int = 16
@export var speed: float = 200
@export var speed_increase: float = 0.1
@export var max_speed: int = 500

@export var color: Color = Color.WHITE

signal predicted_ball_bounce(y: int)
signal ball_exited_screen

func _ready() -> void:
	var img = Image.create(ball_size, ball_size, false, Image.FORMAT_RGBA8)
	img.fill(color)
	
	var tex = ImageTexture.create_from_image(img)
	
	$BallSprite.texture = tex
	
	reset()
	print("Ball speed: ", velocity.length())
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if collision != null:
		velocity = velocity.bounce(collision.get_normal())

		velocity = velocity.normalized() * min(velocity.length() * (1 + speed_increase), max_speed)
		
		check_and_emit_ball_bounce_position(position, velocity)
		
		var collider = collision.get_collider()
		if collider.name == "Paddle":
			high_bounce_sound.play()
		else:
			low_bounce_sound.play()
		
		if velocity.length() < max_speed:
			print("Ball speed: %d" % velocity.length())

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	ball_exited_screen.emit()

func reset() -> void:
	var dir = Vector2(randf_range(-1, 1), randf_range(-0.3, 0.3)).normalized() 
	velocity = dir * speed
	position = screen_size / 2
	
	if dir.x > 0:
		check_and_emit_ball_bounce_position(position, velocity)

func check_and_emit_ball_bounce_position(ball_pos: Vector2, ball_vel: Vector2) -> void:
	if velocity.x > 0:
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
