extends CharacterBody2D

@onready var low_bounce_sound: AudioStreamPlayer = $LowBounceSound
@onready var high_bounce_sound: AudioStreamPlayer = $HighBounceSound

@export var ball_size: int = 8
@export var speed: float = 200
@export var speed_increase: float = 0.05
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
	
func _process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if collision != null:
		velocity = velocity.bounce(collision.get_normal())

		velocity = velocity.normalized() * min(velocity.length() * (1 + speed_increase), max_speed)
		ball_bounced.emit(position, velocity)
		
		if not Global.mute_toggle:
			var collider = collision.get_collider()
			if collider.name == "Paddle":
				high_bounce_sound.play()
			else:
				low_bounce_sound.play()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	ball_exited_screen.emit()

func reset() -> void:
	var dirx = randi_range(-1, 1)
	if dirx == 0:
		dirx = 1
	
	var diry = randf_range(-0.5, 0.5)
	if diry > -0.1:
		diry -= 0.1
	elif diry < 0.1:
		diry += 0.1
	
	var dir = Vector2(dirx, diry).normalized() 
	velocity = dir * speed
	position = Vector2(Global.SCREEN_SIZE.x, Global.SCREEN_SIZE.y) / 2
