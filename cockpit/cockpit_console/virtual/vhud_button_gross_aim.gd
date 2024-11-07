
class_name VHUDButtonGrossAim
extends VHUDButtonTap

@export var mechbody : MechBody

@export var fine_p = 0.05
@export var fine_i = 1.5

@export var gross_p = 4.0
@export var gross_i = 1.5

@onready var status = $Status

var state = "gross"

func _on_button_clicked():
	var rpid : PidController = mechbody.right_hand_bit.limb_rotator.ppid
	var lpid : PidController = mechbody.left_hand_bit.limb_rotator.ppid
	
	# set fine
	if state == "gross":
		
		rpid.p_tune = fine_p
		rpid.i_tune = fine_i
		
		lpid.p_tune = fine_p
		lpid.i_tune = fine_i
		
		state = "fine"
	
	# set gross
	elif state == "fine":
		
		rpid.p_tune = gross_p
		rpid.i_tune = gross_i
		
		lpid.p_tune = gross_p
		lpid.i_tune = gross_i
		
		state = "gross"
	
	status.text = state
