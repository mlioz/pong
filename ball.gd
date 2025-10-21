extends CharacterBody2D

@onready var low_bounce_sound: AudioStreamPlayer = $LowBounceSound
@onready var high_bounce_sound: AudioStreamPlayer = $HighBounceSound

@onready var screen_size: Vector2 = get_viewport().size

@export var ball_size: int = 16
@export var speed: float = 200
@export var speed_increase: float = 0.1
@export var max_speed: int = 500

@export var color: Color = Color.WHITE

signal ball_bounced(pos: Vector2, vel: Vector2)
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
		ball_bounced.emit(position, velocity)
		
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
