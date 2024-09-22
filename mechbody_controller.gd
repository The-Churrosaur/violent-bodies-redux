
## good lord theres penice

## reworking with yoke inputs and movement states
## only handles default (always on) inputs from the yokes

class_name MechbodyController
extends XRInputProcessor


@export_group("References")
@export var body : MechBody
@export var flight_effects : Node3D
@export var pull_thruster : PullThruster
@export var arm_aimer_hand_remote : Node3D

@export var hand_manager_left : MechHandToolManager
@export var hand_manager_right : MechHandToolManager

@export var headlook_controller : HeadlookController
@export var movement_mode_controller : MovementModeController

@export_group("stick movement")
@export var tranlation_mult = 0.5
@export var rotation_mult = 0.5
@export var flight_thrust_mult = 0.6

@onready var arm_center = $ArmCenter ## points towards left hand
@onready var arm_center_reference = $ArmCenterReference
@onready var arm_aimer = $ArmAimer
@onready var headset_local = $HeadsetLocal

var alt_look = true
var headlook_hold = false



# CALLBACKS ========================================================================================



func _physics_process(delta):
	if !active: return
	
	# get inputs
	
	var rtrigger = _get_right_input("trigger")
	var ltrigger = _get_left_input("trigger")
	
	var primary = _get_right_input("primary")
	var secondary = _get_left_input("secondary")
	
	var rx = _get_right_input("ax_button")
	var ry = _get_right_input("by_button")
	
	var lx = _get_left_input("ax_button")
	var ly = _get_left_input("by_button")
	
	# STICK MOVEMENT
	
	body.front_input += secondary.y * tranlation_mult
	body.strafe_input += secondary.x * tranlation_mult
	
	if movement_mode_controller.get_current_state_id() == "flight":
		body.front_input += secondary.y * flight_thrust_mult
	
	body.roll_input += primary.x * rotation_mult
	body.pitch_input += primary.y * rotation_mult
	
	if ry: body.climb_input += tranlation_mult
	if rx: body.climb_input -= tranlation_mult


func _on_input_down(action, controller):
	super(action, controller)
	
	if controller.type == "left": _on_left_input_down(action)
	if controller.type == "right": _on_right_input_down(action)


func _on_input_up(action, controller):
	super(action, controller)
	
	if controller.type == "left": _on_left_input_up(action)
	if controller.type == "right": _on_right_input_up(action)


func _on_left_input_down(action):
	
	if action == "ax_button":
		hand_manager_left.next_tool()
	
	if action == "by_button":
		enter_flight()
	
	if action == "trigger_click":
		hand_manager_right.current_tool.input("trigger")
	

func _on_left_input_up(action):
	
	if action == "by_button":
		exit_flight()


func _on_right_input_down(action):

	if action == "ax_button":
		#hand_manager_right.next_tool()
		pass
	#
	if action == "by_button":
		#alt_look = false
		#headlook_controller.enabled = true
		#headlook_hold = true
		if movement_mode_controller.get_current_state_id() == "skate":
			body.boost_up(0.01)
	
	if action == "trigger_click":
		hand_manager_left.current_tool.input("trigger")


func _on_right_input_up(action):
	
	#if action == "by_button":
		#alt_look = true
		#headlook_controller.enabled = false
		#headlook_hold = false
	pass


func _on_yoke_grabbable_left_grabbed(grabber):
	active = true


func _on_yoke_grabbable_left_dropped(grabber):
	active = false
	pass # Replace with function body.


func _on_yoke_grabbable_right_grabbed(grabber):
	active = true


func _on_yoke_grabbable_right_dropped(grabber):
	active = false
	if headlook_hold: headlook_controller.enabled = false


# PUBLIC -------------------------------------------------------------------------------------------


func enter_flight():
	movement_mode_controller.enter_state("flight")


func exit_flight():
	movement_mode_controller.enter_state("default")
	
	#777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777`;p1.l1gfm,k-0.[2]
	# - A.B. Snuggle
