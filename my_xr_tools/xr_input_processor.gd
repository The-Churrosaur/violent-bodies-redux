
## API FOR ACCESSING GLOBAL CONTROLLER INPUTS.
## designed to be inherited - mostly for ease of calling


class_name XRInputProcessor
extends Node3D


## will not send input signals or query inputs if false
@export var active = true

## if true, will only process inputs from controller in controller_filter
@export var use_controller_filter = false

## approved controller
@export var controller_filter : MyXRController

var left = XRPlayerGlobals.CONTROLLERS.LEFT
var right = XRPlayerGlobals.CONTROLLERS.RIGHT


# CALLBACKS --------------------------------------------------------------------



func _ready():
	XRPlayerGlobals.controller_input_pressed.connect(_on_input_down_global)
	XRPlayerGlobals.controller_input_released.connect(_on_input_up_global)
	XRPlayerGlobals.controller_float_changed.connect(_on_float_changed_global)
	XRPlayerGlobals.controller_vec2_changed.connect(_on_vec2_changed_global)


func _on_input_down_global(action : String, controller : MyXRController):
	if !active : return
	if use_controller_filter and controller != controller_filter: return
	
	_on_input_down(action, controller)


func _on_input_up_global(action : String, controller : MyXRController):
	if !active : return
	if use_controller_filter and controller != controller_filter: return
	
	_on_input_up(action, controller)


func _on_float_changed_global(action : String, value : float, controller : MyXRController):
	if !active : return
	if use_controller_filter and controller != controller_filter: return
	
	_on_float_changed(action, value, controller)


func _on_vec2_changed_global(action : String, value : Vector2, controller : MyXRController):
	if !active : return
	if use_controller_filter and controller != controller_filter: return
	
	_on_vec2_changed(action, value, controller)


## inherit these functions vv


func _on_input_down(action : String, controller : MyXRController):
	pass

func _on_input_up(action : String, controller : MyXRController):
	pass

func _on_float_changed(action : String, value : float, controller : MyXRController):
	pass

func _on_vec2_changed(action : String, value : Vector2, controller : MyXRController):
	pass



# PRIVATE ----------------------------------------------------------------------



# -- INPUT QUERYING


func _get_input(action, controller_type) -> Variant:
	if !active: return null
	return XRPlayerGlobals.get_input(action, controller_type)


func _is_pressed(action, controller_type) -> bool:
	if !active: return false
	return XRPlayerGlobals.is_pressed(action, controller_type)


func _get_filtered_input(action) -> Variant:
	if !use_controller_filter: return null
	return _get_input(action, controller_filter.type)


func _is_filtered_pressed(action) -> bool:
	if !use_controller_filter: return false
	return _is_pressed(action, controller_filter.type)


# these are kind of bad but also nice
# note - will OVERRIDE filters


func _get_left_input(action) -> Variant:
	return _get_input(action, left)


func _get_right_input(action) -> Variant:
	return _get_input(action, right)


func _left_button_pressed(action) -> bool:
	return _is_pressed(action, left)


func _right_button_pressed(action) -> bool:
	return _is_pressed(action, right)
