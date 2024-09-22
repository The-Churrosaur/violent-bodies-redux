
class_name MovementModeStateSkate
extends MovementModeState

@export var headlook_controller : HeadlookController
@export var flight_module_yaw : FlightModule
@export var mechbody : MechBody
@export var rotator : MechRotator
@export var floor_normal_reference_node : Node3D


func _physics_process(delta):
	
	if is_active_state:
		
		# downforce
		mechbody.climb_input = -0.5
		
		# skate
		mechbody.yaw_mult = 1 - abs(mechbody.front_input)
		mechbody.yaw_input += mechbody.roll_input * mechbody.front_input * 4
	


func enter_state():
	super()
	headlook_controller.pitch_disabled = true
	flight_module_yaw.enabled = true
	rotator.track_target(floor_normal_reference_node)


func exit_state():
	super()
	headlook_controller.pitch_disabled = false
	flight_module_yaw.enabled = false
	rotator.stop_tracking()
	mechbody.yaw_mult = 1.0
