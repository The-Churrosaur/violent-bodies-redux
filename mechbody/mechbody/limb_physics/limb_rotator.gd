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

## will attempt to match position of target
@export var translation = true

## rotation torque on body
@export var max_torque_impulse = 0.1
@export var max_translation_impulse = 0.8
@export var damp = 0.5

@export var recoil_body : RigidBody3D ## equal and opposite

@export var rotate_by_axis = false
@export var match_x = true
@export var match_y = false
@export var match_z = true


@onready var rpid = $RotationalPidController
@onready var ppid = $PositionalPidController



func _physics_process(delta):
	if !active: return
	if target == null: return
	
	if rotate_by_axis:
		if match_x: _rotate_local_x(delta)
		if match_y: _rotate_local_y(delta)
		if match_z: _rotate_local_z(delta)
	else:
		_rotate_along_axis(delta)
	
	if translation : _apply_translation()


func _rotate_local_x(delta):
	var error = target.rotation.x - rotation.x
	_apply_rotation_along(basis.x, error, delta)

func _rotate_local_y(delta):
	var error = target.rotation.y - rotation.y
	_apply_rotation_along(basis.y, -error, delta)

func _rotate_local_z(delta):
	var error = target.rotation.z - rotation.z
	_apply_rotation_along(basis.z, error, delta)


func _rotate_along_axis(delta):
	
	var b_basis = body.global_basis
	var t_basis = target.global_basis
	
	var error_basis : Basis = t_basis * b_basis.inverse()
	var error_quat = error_basis.get_rotation_quaternion()
	
	var error_axis = error_quat.get_axis().normalized()
	var error_angle = error_quat.get_angle()
	
	if debug: 
		print("target rotation: ", target.rotation)
		print("body rotation: ", body.rotation)
		print("ERROR AXIS: ", error_axis)
		pass
	
	_apply_rotation_along(error_axis, error_angle, delta)


func _apply_rotation_along(axis : Vector3, angle, delta):
	var k = rpid.solve(angle)
	if debug: print("applying rotation k: ", k)
	body.apply_torque_impulse(axis * max_torque_impulse * k)


func _apply_translation():
	
	var towards = target.global_position - body.global_position
	var length = towards.length()
	var k = ppid.solve(length)
	if debug: print("TRANS K: ", k)
	
	# dampening by length
	var relative_vel = target.linear_velocity - body.linear_velocity
	var d = damp * relative_vel / length 
	
	var impulse = k * towards * max_translation_impulse
	
	body.apply_central_impulse(impulse)
	body.apply_central_impulse(d)
	
	# wheee
	if recoil_body != null:
		recoil_body.apply_central_impulse(-impulse)
		recoil_body.apply_central_impulse(-d)
