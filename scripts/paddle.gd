extends StaticBody2D
class_name Paddle

const PADDLE_SCENE: PackedScene = preload("res://scenes/paddle.tscn")
const PADDLE_SIZE: Vector2 = Vector2(8, 64)

@export var speed: float = 500
@export var color: Color = Color.RED
@export var control_method: Global.ControlMethod = Global.ControlMethod.WASD

var new_position: Vector2

func _ready() -> void:
	$PlayerSprite.texture = draw_paddle(color)
	
	if control_method == Global.ControlMethod.COMPUTER:
		new_position = position

static func new_paddle(_color: Color, _control_method: Global.ControlMethod) -> Paddle:
	var paddle = PADDLE_SCENE.instantiate()
	
	paddle.color = _color
	paddle.control_method = _control_method
	
	return paddle

func reset_position(xpos: float, ypos: float) -> void:
	position.x = xpos
	position.y = ypos

func _process(delta: float) -> void:
	
	if control_method == Global.ControlMethod.COMPUTER:
		position.y = move_toward(position.y, new_position.y, speed * delta)

	else:
		var axis
		if control_method == Global.ControlMethod.ARROWS:
			axis = Input.get_axis("ui_up", "ui_down")
		else:
			axis = Input.get_axis("w", "s")
		
		position.y += axis * speed * delta
		
	# Prevents the paddle from going off the screen
	position.y = clampf(position.y, PADDLE_SIZE.y / 2, Global.SCREEN_SIZE.y - PADDLE_SIZE.y / 2)

func draw_paddle(paddle_color: Color) -> ImageTexture:
	var img = Image.create(int(PADDLE_SIZE.x), int(PADDLE_SIZE.y), false, Image.FORMAT_RGBA8)
	img.fill(paddle_color)
	
	return ImageTexture.create_from_image(img)

func on_ball_bounce(pos: Vector2, vel: Vector2) -> void:
	new_position.y = get_ball_path(pos, vel)
	
func get_ball_path(pos: Vector2, vel: Vector2) -> int:
	 #Using a parametric line equation to define the ball's path to find what y value it will bounce on the AI's wall
	 #pos = (posx, posy)
	 #vel = (velx, vely)
	 #x(t) = posx + velx*t
	 #y(t) = posy + vely*t
	 #t = (x - pox)/velx
	 #y = posy + vely/velx*(x-posx)

	return pos.y + vel.y/vel.x * (position.x - pos.x)
