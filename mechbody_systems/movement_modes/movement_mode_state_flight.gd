
extends MovementModeState

@export var flight_module_pitch : FlightModule
@export var flight_module_yaw : FlightModule
@export var body : MechBody
@export var headlook_controller : HeadlookController


func _physics_process(delta):
	
	if is_active_state:
		body.front_input += 0.5
	
	pass

func enter_state():
	super()
	flight_module_pitch.enabled = true
	flight_module_yaw.enabled = true
	#headlook_controller.use_flight_values = true
	#body.yaw_mult = 0.7
	#body.pitch_mult = 0.7


func exit_state():
	super()
	flight_module_pitch.enabled = false
	flight_module_yaw.enabled = false
	#headlook_controller.use_flight_values = false
	body.yaw_mult = 1.0
	body.pitch_mult = 1.0

func can_enter() -> bool :
	return true
