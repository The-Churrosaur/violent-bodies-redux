
class_name NodeStateManager
extends Node


@export var starting_state : NodeState

var current_state : NodeState = null
var previous_state : NodeState = null


func _ready() -> void:
	change_state(starting_state)


func change_state(state : NodeState):
	state.set_state(previous_state)
	previous_state = current_state
	current_state = state
