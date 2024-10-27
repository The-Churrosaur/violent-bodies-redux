extends MovementModeState

@export var downforce = 40
@export var floor_detector : FloorDetector
@export var mechbody : MechBody
@export var mech_booster : MechBooster
@export var headlook_controller : HeadlookController


func _physics_process(delta):
	if is_active_state:
		var normal = floor_detector.get_collision_normal()
		mechbody.apply_central_impulse(normal * -downforce)


func enter_state():
	super()
	print("jumping")
	mechbody.boost_up(0.01)
	mech_booster.boost_fore(0.4 * mechbody.front_input)
	mech_booster.boost_strafe(0.4 * mechbody.strafe_input)
	
	headlook_controller.pitch_disabled = true
	headlook_controller.roll_disabled = true


func exit_state():
	super()
	
	headlook_controller.pitch_disabled = false
	headlook_controller.roll_disabled = false
	pass
