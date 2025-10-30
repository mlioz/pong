extends Control

@export var player_1_option_button: OptionButton
@export var player_2_option_button: OptionButton
@export var quit_button: Button

func _ready() -> void:
	for i in Global.ControlMethod.keys():
		player_1_option_button.add_item(i)
		player_2_option_button.add_item(i)
	
	player_1_option_button.select(0)
	player_2_option_button.select(0)
	
	if OS.has_feature("web"):
		quit_button.hide()

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_player_1_option_button_item_selected(index: int) -> void:
	Global.player_1_control_method = get_control_method_by_index(index)
	
func _on_player_2_option_button_item_selected(index: int) -> void:
	Global.player_2_control_method = get_control_method_by_index(index)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func get_control_method_by_index(index) -> Global.ControlMethod:
	match index:
		Global.ControlMethod.COMPUTER:
			return Global.ControlMethod.COMPUTER
		Global.ControlMethod.ARROWS:
			return Global.ControlMethod.ARROWS
		_:
			return Global.ControlMethod.WASD
