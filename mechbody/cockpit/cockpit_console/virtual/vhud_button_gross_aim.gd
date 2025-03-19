
class_name VHUDButtonGrossAim
extends VHUDButtonTap

@export var mechbody : MechBody

@onready var status = $Status

var state = "gross"

func _on_button_clicked():
	var rpid : PidController = mechbody.right_hand_bit.limb_rotator.ppid
	var lpid : PidController = mechbody.left_hand_bit.limb_rotator.ppid
	
	# set fine
	if state == "gross":
		rpid.set_tuning_config("trans_fine")
		lpid.set_tuning_config("trans_fine")
		
		state = "fine"
	
	# set gross
	elif state == "fine":
		rpid.set_tuning_config("trans_default")
		lpid.set_tuning_config("trans_default")
		state = "gross"
	
	status.text = state
