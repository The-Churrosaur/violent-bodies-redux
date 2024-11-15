
class_name MovementModeStateSkate
extends MovementModeState

@export var downforce = 200
@export var breakaway_distance = 10.0
@export var lean_skate_mult = 0.1

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
		mechbody.legbody.apply_central_impulse(normal * -downforce)
		
		# skate
		#mechbody.yaw_mult = 1 - abs(mechbody.front_input)
		mechbody.yaw_mult = 2
		#mechbody.yaw_input = 0
		#mechbody.strafe_input = -mechbody.last_rotat.z * lean_skate_mult
		#mechbody.yaw_input += mechbody.last_rotat.z * lean_skate_mult
		
		
		var last_lean = mechbody.last_rotat.z
		mechbody.strafe_input += sign(last_lean) * 0.1 * mechbody.last_trans.z
		mechbody.yaw_input += last_lean
		
		# leave
		if floor_detector.get_distance() > breakaway_distance: 
			print(floor_detector.get_distance())
			print("floor detector left floor: hovering")
			controller.enter_state()


func enter_state():
	super()
	headlook_controller.pitch_disabled = true
	headlook_controller.roll_disabled = false
	headlook_controller.yaw_disabled = false
	flight_module_yaw.enabled = true
	#rotator.track_match_target(floor_normal_reference_node, true)
	
	mechbody.enable_legs()
	mechbody.angular_damp = 10


func exit_state():
	super()
	# xdsszzdssssssssssssssZASSSSSwwwwwwwwwwwiu8888888888888
	headlook_controller.pitch_disabled = false
	flight_module_yaw.enabled = false
	rotator.stop_tracking()
	mechbody.yaw_mult = 1.0
	
	mechbody.angular_damp = 2

