
class_name MovementModeState
extends Node

@export var mode_id = "default"

var controller : MovementModeController
var is_active_state = false

func enter_state():
	is_active_state = true

func exit_state():
	is_active_state = false

func can_enter() -> bool :
	return true
