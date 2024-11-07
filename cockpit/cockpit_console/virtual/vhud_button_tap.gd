
class_name VHUDButtonTap
extends VHUDButtonGrabbable

func _hover(grabbable):
	super(grabbable)
	print("vhud tap button hovered: ", name)
	_press()
	if controller != null: controller.trigger_haptic_pulse("haptic", 10, 0.3, 0.1, 0)
