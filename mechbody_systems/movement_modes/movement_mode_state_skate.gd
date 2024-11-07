
class_name MovementModeStateSkate
extends MovementModeState

@export var downforce = 20
@export var breakaway_distance = 4.0

@export var headlook_controller : HeadlookController
@export var flight_module_yaw : FlightModule
@export var mechbody : MechBody
@export var rotator : MechRotator
@export var floor_normal_reference_node : Node3D
@export var floor_detector : FloorDetector


func _physics_process(delta):
	
	if is_active_state:
		
		# downforce
		var normal = floor_detector.get_collision_normal()
		mechbody.apply_central_impulse(normal * -downforce)
		
		# skate
		#mechbody.yaw_mult = 1 - abs(mechbody.front_input)
		mechbody.yaw_mult = 2
		mechbody.yaw_input += mechbody.roll_input * mechbody.front_input * 4
		
		# leave
		if floor_detector.get_distance() > breakaway_distance: 
			print(floor_detector.get_distance())
			print("floor detector left floor: hovering")
			controller.enter_state("hover")


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

