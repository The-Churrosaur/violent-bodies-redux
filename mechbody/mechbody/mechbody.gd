## physical movement of the mech.
## set input attributes with controller

class_name MechBody
extends RigidBody3D

signal landed()
signal takeoff()

@export var player = true
@export var thrust_power = 500000.0
@export var torque_power = 180000.0
@export var step_power = 100000.0
@export var step_push_time = 0.2
@export var min_step_fall_time = 0.2
@export var angular_shake_velocity = PI / 2

@export_group("references")
@export var seat_parent : Node3D
@export var cockpit : Cockpit
@export var left_arm_targeter : ArmTargeter
@export var right_arm_targeter : ArmTargeter
@export var left_player_shoulder : Node3D
@export var right_player_shoulder : Node3D
@export var step_push_timer : Timer
@export var step_fall_timer : Timer
@export var movement_mode_controller : MovementModeController
@export var left_hand_bit : HandBit
@export var right_hand_bit : HandBit

# set by controller.
# assume 0-1 but it's multiplicative
var pitch_input = 0
var roll_input = 0
var yaw_input = 0

var front_input = 0
var strafe_input = 0
var climb_input = 0

var pitch_mult = 1.0
var roll_mult = 1.0
var yaw_mult = 1.0

var walk = true

# utility vars
var fore
var right
var up

var is_landed = false

var is_step_pushing = false
var is_step_falling = false


func _physics_process(delta):
	
	fore = transform.basis.z
	right = transform.basis.x 
	up = transform.basis.y
	
	# strafe
	apply_central_force(right * thrust_power * delta * strafe_input)
	# fore/reverse
	apply_central_force(fore * -thrust_power * delta * front_input)
	# climb
	apply_central_force(up * thrust_power * delta * climb_input)
	
	# pitch
	apply_torque(right * -torque_power * delta * pitch_input * pitch_mult)
	# roll
	apply_torque(fore * -torque_power * delta * roll_input * roll_mult)
	# yaw
	apply_torque(up * -torque_power * delta * yaw_input * yaw_mult)
	
	# -- walking
	
	if walk and is_landed: 
		
		# start walking if not currently
		if !is_step_falling and !is_step_pushing: _start_step()
		
		# push if pushing
		if is_step_pushing: apply_central_force(up * step_power * delta)
	
	# -- angular shake
	
	var vel = angular_velocity.length()
	if vel >= angular_shake_velocity and player:
		
		var amp = vel * 0.2
		XRPlayerGlobals.lhand.trigger_haptic_pulse("haptic",0.1, amp, 0.2, 0)
		XRPlayerGlobals.rhand.trigger_haptic_pulse("haptic",0.1, amp, 0.1, 0)
	
	
	# clear inputs at end
	clear_inputs()


func boost_forwards(mult = 1.0):
	apply_central_impulse(fore * -thrust_power * mult)

func boost_up(mult = 1.0):
	apply_central_impulse(up * thrust_power * mult)


func clear_inputs():
	
	pitch_input = 0
	roll_input = 0
	yaw_input = 0
	
	front_input = 0
	strafe_input = 0
	climb_input = 0


# -- CALLBACKS

func _on_body_entered(body):
	if body.is_in_group("ground"): 
		print("GROUNDED")
		landed.emit()
		is_landed = true
		movement_mode_controller.enter_state("skate")


func _on_body_exited(body):
	if body.is_in_group("ground"): 
		takeoff.emit()
		is_landed = false
		movement_mode_controller.enter_state()


# -- STEP CALLBACKS

func _on_step_push_timer_timeout():
	
	#print("STEP FALLING")
	is_step_pushing = false
	is_step_falling = true
	
	step_fall_timer.start(min_step_fall_time)


func _start_step():
	
	if !is_landed : await landed
	
	#print("STARTING STEP")
	is_step_pushing = true
	is_step_falling = false
	step_push_timer.start(step_push_time)


func _on_step_fall_timer_timeout():
	if walk and is_step_falling: _start_step()


# OTHER PUBLIC -----------------------------------------------------------------------



func rotate_seat(y):
	seat_parent.rotate_y(y)

func get_headset_rot():
	return seat_parent.rotation.y + XRPlayerGlobals.headset.rotation.y


func destroyed_enemy(enemy):
	# global controller shake
	if player:
		XRPlayerGlobals.lhand.trigger_haptic_pulse("haptic", 5, 1.0, 0.2, 0)
		XRPlayerGlobals.rhand.trigger_haptic_pulse("haptic", 5, 0.4, 0.1, 0)