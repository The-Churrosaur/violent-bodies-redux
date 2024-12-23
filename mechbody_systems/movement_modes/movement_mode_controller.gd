
## arbitrates between mech movement modes (flight, orbit) and the mechbody
## receives commands from buttons and mechbody controller


class_name MovementModeController
extends Node3D


signal mode_changed(state_id)


var states = {}
var current_state : MovementModeState = null
var previous_state : MovementModeState = null



# CALLBACKS ========================================================================================



func _ready():
	# collect children as states
	for child in get_children():
		if child is MovementModeState: 
			states[child.mode_id] = child
			child.controller = self
	
	print("MOVEMENT MODES: ", states)
	
	await get_tree().create_timer(0.1).timeout
	enter_state()



# PUBLIC ===========================================================================================



## switches states - returns success or failure
func enter_state(state_id = "default") -> bool:
	
	#print("attempting to enter state: ", state_id)
	
	if !states.has(state_id): return false
	
	var state = states[state_id]
	if !state.can_enter(): return false
	
	if current_state != null: current_state.exit_state()
	state.enter_state()
	
	previous_state = current_state
	current_state = state
	mode_changed.emit(state.mode_id)
	
	return true


func get_current_state_id():
	if current_state != null: return current_state.mode_id
	else: return null
