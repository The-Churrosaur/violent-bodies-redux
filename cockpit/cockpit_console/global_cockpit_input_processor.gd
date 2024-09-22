
## handles 'always on' player input for when player is in cockpit. 
## ie. stick magnets on grab

class_name GlobalCockpitInputProcessor
extends XRInputProcessor

signal stick_grabbed(controller)
signal stick_released(controller)

@export var left_stick : MyXRGrabbable
@export var right_stick : MyXRGrabbable
@export var headlook : HeadlookController

var left_stick_is_grabbed = false
var right_stick_is_grabbed = false
var any_stick_is_grabbed = false

func _on_input_down(action, controller):
	super(action, controller)
	
	# stick magnet
	if action == "grip_click":
		
		if controller == XRPlayerGlobals.lhand:
			controller.hand_grabber.force_grab(left_stick)
			left_stick_is_grabbed = true
		if controller == XRPlayerGlobals.rhand:
			controller.hand_grabber.force_grab(right_stick)
			right_stick_is_grabbed = true
		
		if (left_stick_is_grabbed or right_stick_is_grabbed): 
			any_stick_is_grabbed = true
		
		stick_grabbed.emit(controller)


func _on_input_up(action, controller):
	super(action, controller)
	
	if action == "grip_click":
		
		if controller == XRPlayerGlobals.lhand:
			left_stick_is_grabbed = false
		if controller == XRPlayerGlobals.rhand:
			right_stick_is_grabbed = false
		
		if !(left_stick_is_grabbed or right_stick_is_grabbed): 
			any_stick_is_grabbed = false
		
		
		stick_released.emit(controller)
	
	
