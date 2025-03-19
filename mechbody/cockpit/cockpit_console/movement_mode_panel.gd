extends Label3D

@export var movement_mode_controller: MovementModeController

func _physics_process(delta):
	if movement_mode_controller and movement_mode_controller.current_state:
		text = "MOVEMENT MODE: " + movement_mode_controller.current_state.mode_id
