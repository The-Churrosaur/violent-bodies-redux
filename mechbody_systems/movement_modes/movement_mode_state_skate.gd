
class_name MovementModeStateSkate
extends MovementModeState

@export var headlook_controller : HeadlookController
@export var flight_module_yaw : FlightModule
@export var mechbody : MechBody
@export var rotator : MechRotator
@export var floor_normal_reference_node : Node3D
@export var floor_detector : FloorDetector


func _physics_process(delta):
	
	if is_active_state:
		
		# downforce
		mechbody.climb_input = -0.5
		
		# skate
		mechbody.yaw_mult = 1 - abs(mechbody.front_input)
		mechbody.yaw_input += mechbody.roll_input * mechbody.front_input * 4
		
		# leave
		if !floor_detector.is_colliding(): controller.enter_state()
	


func enter_state():
	super()
	headlook_controller.pitch_disabled = true
	flight_module_yaw.enabled = true
	#rotator.track_match_target(floor_normal_reference_node, true)


func exit_state():
	super()
	# xdsszzdssssssssssssssZASSSSSwwwwwwwwwwwiu8888888888888
	headlook_controller.pitch_disabled = false
	flight_module_yaw.enabled = false
	rotator.stop_tracking()
	mechbody.yaw_mult = 1.0
