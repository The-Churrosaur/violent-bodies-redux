## move/remote transform the stick node


class_name HandStick
extends Node3D

@export var mechbody : MechBody
@export var stick : Node3D
@export var translate = false

@export_category("params")

@export var strafe_deadzone = 0.01
@export var front_deadzone = 0.03
@export var climb_deadzone = 0.01

@export var yaw_deadzone = PI/8
@export var roll_deadzone = PI/8
@export var pitch_deadzone = PI/8

@export var strafe_mult = 4.0
@export var front_mult = 4.0
@export var climb_mult = 5.0

@export var yaw_mult = 0.5
@export var roll_mult = 0.2
@export var pitch_mult = 0.5

var pitch_assist_input = 0
var yaw_assist_input = 0
var roll_assist_input = 0


func _physics_process(delta):
	
	var yaw_rot = stick.rotation.y
	var roll_rot = stick.rotation.z
	var pitch_rot = stick.rotation.x
	
	if yaw_rot * yaw_assist_input > 0: yaw_rot += yaw_assist_input
	if pitch_rot * pitch_assist_input >0: pitch_rot += pitch_assist_input
	
	if abs(yaw_rot) > yaw_deadzone:
		mechbody.yaw_input -= (yaw_rot * yaw_mult)
	
	if abs(roll_rot) > roll_deadzone:
		mechbody.roll_input -= (roll_rot * roll_mult) 
		if roll_rot * roll_assist_input > 0: mechbody.roll_input += roll_assist_input * 4
	
	if abs(pitch_rot) > pitch_deadzone:
		mechbody.pitch_input -= (pitch_rot * pitch_mult)
	
	if translate:
	
		var strafe_disp = stick.position.x
		var front_disp = stick.position.z
		var climb_disp = stick.position.y
		
		if abs(strafe_disp) > strafe_deadzone:
			mechbody.strafe_input += strafe_disp * strafe_mult
		
		if abs(front_disp) > front_deadzone:
			mechbody.front_input -= front_disp * front_mult
		
		if abs(climb_disp) > climb_deadzone:
			mechbody.climb_input += climb_disp * climb_mult
