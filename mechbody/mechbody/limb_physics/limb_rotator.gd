## encapsulates rotating a given rigidbody to a target vector
## for selection of relative vectors (forward, up, right): 
## finds the cross product to get the axis of rotation,
## applies forces along that axis to match rotation,
## force values mediated by a PID controller,
## multiple vectors to catch rotation along vector axis
## can also do translation


class_name LimbRotator
extends Node3D

@export var debug = false

## will actively apply forces
@export var active = true

## body to be rotated
@export var body : RigidBody3D

## body will attempt to match rotation of target
@export var target : Node3D

## will attempt to match rotation of target
@export var rotate = true

## will attempt to match position of target
@export var translation = true

## rotation torque on body
@export var max_torque_impulse = 0.1
@export var max_translation_impulse = 2.0
@export var max_translation_k = 10.0
## multiplies velocity delta from recoil body
@export var constant_damp = 0.01

## 
@export var rotation_deadzone = 0.1
@export var translation_deadzone = 0.5

@export var recoil_body : RigidBody3D ## equal and opposite
@export var central_recoil = true 
@export var recoil_torque_reduction = 5
@export var recoil_force_multiplier = 0.8

@export var rotate_by_cross = false

@export var rotate_by_axis = false
@export var match_x = true
@export var match_y = false
@export var match_z = true


@onready var rpid = $RotationalPidController
@onready var ppid = $PositionalPidController
# for axis rotation
@onready var local_target_reference = $LocalTargetReference


## for audio etc
var current_impulse = 0



func _physics_process(delta):
	if !active: return
	if target == null: return
	
	if rotate:
		if rotate_by_axis:
			print("rotating by axis...")
			print("body rotation...            ", body.global_rotation)
			local_target_reference.global_rotation = target.global_rotation
			if match_x: _rotate_local_x(delta)
			if match_y: _rotate_local_y(delta)
			if match_z: _rotate_local_z(delta)
		elif rotate_by_cross:
			_rotate_along_cross(delta)
		else:
			_rotate_along_axis(delta)
	
	if translation : _apply_translation()


func _rotate_local_x(delta):
	var error = local_target_reference.rotation.x - rotation.x
	print("x error... ", error)
	print("x basis... ", global_basis.x)
	_apply_rotation_along(local_target_reference.global_basis.x, error, delta)

func _rotate_local_y(delta):
	var error = local_target_reference.rotation.y - rotation.y
	_apply_rotation_along(global_basis.y, -error, delta)

func _rotate_local_z(delta):
	var error = local_target_reference.rotation.z - rotation.z
	print("z error... ", error)
	_apply_rotation_along(global_basis.z, error, delta)


func _rotate_along_cross(delta):
	
	var b_y = body.global_basis.y
	var t_y = target.global_basis.y
	
	var error_axis = b_y.cross(t_y)
	var error_angle = b_y.angle_to(t_y)
	
	_apply_rotation_along(error_axis, error_angle, delta)


func _rotate_along_axis(delta):
	#print("rotating along axis... ", target)
	
	var b_basis = body.global_basis
	var t_basis = target.global_basis
	
	var error_basis : Basis = t_basis * b_basis.inverse()
	var error_quat = error_basis.get_rotation_quaternion()
	
	var error_axis = error_quat.get_axis().normalized()
	var error_angle = error_quat.get_angle()
	
	if debug: 
		#print("target rotation: ", target.rotation)
		#print("body rotation: ", body.rotation)
		#print("ERROR AXIS: ", error_axis)
		pass
	
	_apply_rotation_along(error_axis, error_angle, delta)


func _apply_rotation_along(axis : Vector3, angle, delta):
	if angle < rotation_deadzone: return
	var k = rpid.solve(angle)
	#if debug: print("applying rotation k: ", k)
	body.apply_torque_impulse(axis * max_torque_impulse * k)


func _apply_translation():
	
	var towards = target.global_position - body.global_position
	var length = towards.length()
	if length < translation_deadzone: return
	var k = min(ppid.solve(length), max_translation_k)
	if debug: print("TRANS K: ", k)
	#var k = ppid.solve(length)
	#var label_3d = $"../../Anchor/Label3D"
	#label_3d.text = "TRANKS: " + str(k)

	# damping motion relative to parent body
	var relative_vel = recoil_body.linear_velocity - body.linear_velocity
	var d = relative_vel * constant_damp
	
	#var d = -constant_damp * towards / length
	
	var impulse = k * towards.normalized() * max_translation_impulse
	current_impulse = impulse.length_squared()
	#if impulse.length_squared() <= 25: return
	
	#if debug: print("DISTANCE: ", length)
	#if debug: print("IMPULSE: ", impulse.length())
	#label_3d.text = "IMPULSE: " + str(impulse.length())
	#label_3d.text = "D: " + str(d.length())
	if debug: print("D: ", d.length())
	
	body.apply_central_impulse(impulse + d)
	
	# wheee
	if recoil_body != null:
		if central_recoil:
			recoil_body.apply_central_impulse((-impulse -d) * recoil_force_multiplier)
		else:
			var pos = (body.global_position - recoil_body.global_position) \
											/ recoil_torque_reduction
			recoil_body.apply_impulse((-impulse -d) * recoil_force_multiplier, pos)
