
class_name VHUDButtonOrbit
extends VHUDButtonTap

@export var movement_controller : MovementModeController
@export var orbit_state_id = "orbit"

func _on_button_clicked():
	if movement_controller.get_current_state_id() == orbit_state_id:
		movement_controller.enter_state()
	else:
		movement_controller.enter_state(orbit_state_id)
