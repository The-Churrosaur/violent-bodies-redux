
class_name NodeState
extends Node


@export var state_type = "default"

var is_current_state = false 

## set this state
func set_state(previous_state):
	is_current_state = true
