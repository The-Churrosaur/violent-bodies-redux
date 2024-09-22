
class_name HeadlookController
extends Node3D


@export var enabled = false
@export var pitch_disabled = false
@export var roll_disabled = false
@export var yaw_disabled = false

@export_group("references")
@export var body : MechBody
@export var headset_local : HeadsetLocalTransform
# look rotation / movement is in relation to this node 
@export var cockpit_headset_reference : Node3D
@export var cockpit_inputs : GlobalCockpitInputProcessor

@export_group("headset tracking movement")
@export var look_rotation = true
@export var look_pitch = PI/16
@export var look_yaw = PI/16
@export var look_mult = 0.8
@export var look_pitch_mult = 3.0

@export var lean_deadzone = 0.05
@export var lean_roll_mult = 6.0
@export var lean_input_mult = 1
@export var lean_pitch_mult = 3.0


# toggled by sticks and deadzones - disables headlook regardless of enabled
var temp_disabled = false

# activated by movement mode
var use_flight_values = false

# for tracking head movement velocity
var head_last_position: Vector3
var head_velocity: Vector3


func _ready():
	cockpit_inputs.stick_grabbed.connect(_on_cockpit_stick_grabbed)
	cockpit_inputs.stick_released.connect(_on_cockpit_stick_released)

func _physics_process(delta):
	
	if !enabled: return
	if temp_disabled: return
	
	# disabled when no sticks grabbed
	if !cockpit_inputs.any_stick_is_grabbed: return
	
	# LOOK ROTATION
		
	# get angles from cockpit to headset
	# headset_local is child of self
	
	var x = headset_local.rotation.x
	var y = headset_local.rotation.y
	
	if abs(y) > look_yaw:
		body.yaw_input -= y * look_mult
	
	
	# pitch by angle
	if abs(x) > look_pitch:
		body.pitch_input -= x * look_pitch_mult
	
	# LEAN ROLL / pitch
	
	var headset_pos = cockpit_headset_reference.to_local(headset_local.global_position)
	var headset_xz = Vector2(headset_pos.x, -headset_pos.z)
	
	if headset_xz.length_squared() > lean_deadzone * lean_deadzone:
		body.roll_input += headset_xz.x * lean_roll_mult
		
		# dont pitch with forward lean
		# nvm
		var h_y = headset_xz.y
		#h_y= clamp(h_y, -1, 0)
		body.pitch_input += h_y * lean_pitch_mult
	
	# overrides
	if pitch_disabled: body.pitch_input = 0
	if yaw_disabled: body.yaw_input = 0
	if roll_disabled: body.roll_input = 0
	


func _on_cockpit_stick_grabbed(controller):
	pass


func _on_cockpit_stick_released(controller):
	pass


func _on_head_velocity_tracker_timeout():
	
	var head_current_position = headset_local.position
	if head_last_position == null: head_last_position = head_current_position
	head_velocity = head_current_position - head_last_position

