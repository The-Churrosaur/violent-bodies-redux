class_name MovementModeStateHover
extends MovementModeState

@export var rotator : MechRotator
@export var headlook_controller : HeadlookController
@onready var gravity_looker = $GravityLooker


func _physics_process(delta):
	pass


func enter_state():
	super()
	rotator.track_match_target(gravity_looker, false) # true
	#headlook_controller.pitch_disabled = true
	#headlook_controller.roll_disabled = true
	

func exit_state():
	super()
	rotator.stop_tracking()
	headlook_controller.pitch_disabled = false
	headlook_controller.roll_disabled = false
