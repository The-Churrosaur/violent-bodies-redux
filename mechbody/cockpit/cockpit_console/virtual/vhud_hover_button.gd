
class_name VHUDButtonHover
extends VHUDButtonTap

@export var movement_controller : MovementModeController
@export var movement_state_id = "hover"

func _on_button_clicked():
	if movement_controller.get_current_state_id() == movement_state_id:
		movement_controller.enter_state()
	else:
		movement_controller.enter_state(movement_state_id)
