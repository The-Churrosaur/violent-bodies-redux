extends MovementModeState

@export var downforce = 60
@export var floor_detector : FloorDetector
@export var mechbody : MechBody
@export var mech_booster : MechBooster


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


func exit_state():
	super()
	pass
