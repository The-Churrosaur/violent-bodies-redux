extends Node

# injected by player on startup - for reference and input acces

# nodes should just use this reference to make their own signal connections
signal controller_input_pressed(action : String, controller : MyXRController)
signal controller_input_released(action : String, controller : MyXRController)
signal controller_float_changed(action : String, value : float, controller : MyXRController)
signal controller_vec2_changed(action : String, value : Vector2, controller : MyXRController)

signal nodes_set()


## controller type enums - append as necessary
enum CONTROLLERS {LEFT, RIGHT}

## dictionary of controllers - controller enum -> controller.
## set by controllers on set_xr_nodes
var controllers = {}


var lhand : MyXRController
var rhand : MyXRController
var headset : XRCamera3D
var origin : XROrigin3D

var is_nodes_set = false



# CALLBACKS --------------------------------------------------------------------



func _on_controller_input_pressed(action, controller):
	controller_input_pressed.emit(action, controller)


func _on_controller_input_released(action: String, controller):
	controller_input_released.emit(action, controller)


func _on_controller_float_changed(action: String, value: float, controller):
	controller_float_changed.emit(action, value, controller)


func _on_controller_vec2_changed(action: String, value: Vector2, controller):
	controller_vec2_changed.emit(action, value, controller)



# PUBLIC -----------------------------------------------------------------------



## call me ASAP to set nodes
func set_xr_nodes(lhand : MyXRController,\
				  rhand : MyXRController,\
				headset : XRCamera3D, \
				 origin : XROrigin3D):
	
	self.lhand = lhand
	self.rhand = rhand
	self.headset = headset
	self.origin = origin
	
	controllers[lhand.type] = lhand
	controllers[rhand.type] = rhand
	
	lhand.button_pressed.connect(_on_controller_input_pressed.bind(lhand))
	rhand.button_pressed.connect(_on_controller_input_pressed.bind(rhand))
	
	lhand.button_released.connect(_on_controller_input_released.bind(lhand))
	rhand.button_released.connect(_on_controller_input_released.bind(rhand))
	
	lhand.input_float_changed.connect(_on_controller_float_changed.bind(lhand))
	rhand.input_float_changed.connect(_on_controller_float_changed.bind(rhand))
	
	lhand.input_vector2_changed.connect(_on_controller_vec2_changed.bind(lhand))
	rhand.input_vector2_changed.connect(_on_controller_vec2_changed.bind(rhand))
	
	is_nodes_set = true
	emit_signal("nodes_set")


## query controller input
func get_input(action : String, controller_type : CONTROLLERS) -> Variant:
	if !is_nodes_set: return null
	if !controllers.has(controller_type): return null
	
	var controller = controllers[controller_type]
	return controller.get_input(action)


## query controller input
func is_pressed(action : String, controller_type : CONTROLLERS) -> bool:
	if !is_nodes_set: return false
	if !controllers.has(controller_type): return false
	
	var controller = controllers[controller_type]
	return controller.is_button_pressed(action)
