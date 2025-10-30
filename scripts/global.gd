extends Node

const SCREEN_SIZE := Vector2(576, 324)

enum ControlMethod { COMPUTER, WASD, ARROWS }

var player_1_control_method: ControlMethod = ControlMethod.COMPUTER
var player_2_control_method: ControlMethod = ControlMethod.COMPUTER

var mute_toggle: bool = false
