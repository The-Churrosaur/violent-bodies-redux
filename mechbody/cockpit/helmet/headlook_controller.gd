
class_name HeadlookController
extends Node3D


@export var enabled = false
@export var pitch_disabled = false
@export var roll_disabled = false
@export var yaw_disabled = false
@export var lean_boost = false
@export var lean_assist = true

@export_group("references")
@export var body : MechBody
@export var body_controller : MechbodyController
@export var hand_stick : HandStick
@export var headset_local : HeadsetLocalTransform
# look rotation / movement is in relation to this node 
@export var cockpit_headset_reference : Node3D
@export var cockpit_inputs : GlobalCockpitInputProcessor
@export var mech_booster : MechBooster

@export_group("headset tracking movement parameters")
@export var look_rotation = true
@export var look_pitch = PI/32
@export var look_yaw = PI/32
@export var look_mult = 2.0
@export var look_pitch_mult = 5.0

@export var lean_deadzone = 0.1
@export var lean_roll_mult = 4.0
@export var lean_input_mult = 1
@export var lean_pitch_mult = 1.5
@export var lean_boost_threshold = 0.1

@export var crouch_climb_mult = 1.5


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
	
	if lean_assist:
		hand_stick.pitch_assist_input = x
		hand_stick.yaw_assist_input = y
		hand_stick.roll_assist_input = get_headset_xz().x * lean_roll_mult
		
		return
		#TODO
	
	
	if abs(y) > look_yaw: 
		body.yaw_input -= y * look_mult
	
	
	# pitch by angle
	if x > look_pitch:
		body.pitch_input -= x * look_pitch_mult
	
	# LEAN ROLL / pitch / boost
	
	var headset_xz = get_headset_xz()
	
	if headset_xz.length_squared() > lean_deadzone * lean_deadzone:
		
		var h_x = headset_xz.x
		var h_y = headset_xz.y
		
		body.roll_input += headset_xz.x * lean_roll_mult
		
		# dont pitch with forward lean
		# nvm
		#h_y= clamp(h_y, -1, 0)
		body.pitch_input += h_y * lean_pitch_mult
		
		# double pitch input for pulling up
		if h_y < 0: body.pitch_input += h_y * lean_pitch_mult
		
		if lean_boost:
			if abs(h_y) > lean_boost_threshold: 
				print("leaning boost")
				mech_booster.boost_fore(sign(h_y)) # sign 'normalizes' float
			elif abs(h_x) > lean_boost_threshold:
				mech_booster.boost_strafe(sign(h_x))
	
	# experimental crouch
	#body.climb_input += get_headset_pos().y * crouch_climb_mult
	#
	#if body.movement_mode_controller.get_current_state_id() == "skate":
		#var joint : JoltGeneric6DOFJoint3D = body.hip_joint
		#joint.set_param_y(JoltGeneric6DOFJoint3D.PARAM_LINEAR_SPRING_FREQUENCY, 5 + 10 * get_headset_pos().y * crouch_climb_mult)
	
	# overrides
	if pitch_disabled: body.pitch_input = 0
	if yaw_disabled: body.yaw_input = 0
	if roll_disabled: body.roll_input = 0


func get_headset_xz():
	var headset_pos = cockpit_headset_reference.to_local(headset_local.global_position)
	return Vector2(headset_pos.x, -headset_pos.z)

func get_headset_pos():
	return cockpit_headset_reference.to_local(headset_local.global_position)


func _on_cockpit_stick_grabbed(controller):
	pass


func _on_cockpit_stick_released(controller):
	pass


func _on_head_velocity_tracker_timeout():
	
	var head_current_position = headset_local.position
	if head_last_position == null: head_last_position = head_current_position
	head_velocity = head_current_position - head_last_position
