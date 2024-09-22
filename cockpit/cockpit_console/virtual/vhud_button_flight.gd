
class_name VHUDFlightButton
extends VHUDButtonTap

@export var mechbody_controller : MechbodyController
@export var mechbody : MechBody

func _on_button_clicked():
	if mechbody_controller == null: return
	if mechbody_controller.movement_mode_controller.get_current_state_id() == "flight": 
		mechbody_controller.exit_flight()
	else: 
		#mechbody.boost_forwards(0.005)
		mechbody_controller.enter_flight()
