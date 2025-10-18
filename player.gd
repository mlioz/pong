extends StaticBody2D

@onready var screen_size: Vector2 = get_viewport().size

@export var speed: float = 500
@export var paddle_size: Vector2 = Vector2(16, 128)
@export var color: Color = Color.RED

func _ready() -> void:
	$PlayerSprite.texture = create_paddle_texture(color)

func reset_position() -> void:
	position.x = 20
	position.y = screen_size.y / 2

func _process(delta: float) -> void:
	var axis = Input.get_axis("ui_up", "ui_down")
	
	position.y += axis * speed * delta
	
	# Prevents the paddle from going off the screen
	position.y = clampf(position.y, paddle_size.y / 2, screen_size.y - paddle_size.y / 2)

func create_paddle_texture(paddle_color: Color) -> ImageTexture:
	var img = Image.create(int(paddle_size.x), int(paddle_size.y), false, Image.FORMAT_RGBA8)
	img.fill(paddle_color)
	
	return ImageTexture.create_from_image(img)
