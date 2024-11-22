extends MovementModeState

@export var mechbody : MechBody
@export var headlook_controller : HeadlookController

func enter_state():
	super()
	mechbody.disable_legs()
	
	headlook_controller.pitch_disabled = false
	headlook_controller.roll_disabled = false
	headlook_controller.yaw_disabled = false
