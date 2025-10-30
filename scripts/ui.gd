extends CanvasLayer

@export var mute_check_button: CheckButton

func _ready() -> void:
	mute_check_button.button_pressed = Global.mute_toggle

func _on_mute_check_button_toggled(toggled_on: bool) -> void:
	Global.mute_toggle = toggled_on
