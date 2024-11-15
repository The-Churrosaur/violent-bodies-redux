extends MovementModeState

@export var mechbody : MechBody

func enter_state():
	super()
	mechbody.disable_legs()
