
class_name VHUDHeadButton
extends VHUDButtonTap

@export var mech_controller : MechbodyController
@export var headlook_controller : HeadlookController
@onready var info_label = $InfoLabel

func _on_button_clicked():
	# toggle alt look
	mech_controller.alt_look = !mech_controller.alt_look
	headlook_controller.enabled = !headlook_controller.enabled


func _physics_process(delta):
	if headlook_controller.enabled: info_label.text = "HEAD LOOK ENABLED"
	else: info_label.text = ""
