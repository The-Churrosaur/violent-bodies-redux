
## the grabbable object for the cockpit control yokes.
## also parses input for when player is using these yokes.

class_name YokeGrabbable
extends MyXRGrabbableCockpit

@export var rest_point : Marker3D
@export var rest_lerp = 1.0


func _physics_process(delta):
	super(delta)
	#if !is_grabbed:
		#global_transform = global_transform.interpolate_with( \
								#rest_point.global_transform, rest_lerp * delta)

func _hover(grabber : MyXRHandGrabber):
	super(grabber)
	grabber.controller.trigger_haptic_pulse("haptic", 5, 0.4, 0.1, 0)


func _grab(grabber : MyXRHandGrabber):
	super(grabber)
	grabber.controller.trigger_haptic_pulse("haptic", 5, 0.2, 0.3, 0)
