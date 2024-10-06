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
@export var relative_damp = 0.5
@export var constant_damp = 0.1

@export var recoil_body : RigidBody3D ## equal and opposite
@export var central_recoil = true 
@export var recoil_torque_reduction = 5

@export var rotate_by_axis = false
@export var match_x = true
@export var match_y = false
@export var match_z = true


@onready var rpid = $RotationalPidController
@onready var ppid = $PositionalPidController



func _physics_process(delta):
	if !active: return
	if target == null: return
	
	if rotate:
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
	var k = min(ppid.solve(length), max_translation_k)
	if debug: print("TRANS K: ", k)
	
	# doing an interesting thing where damping is inverse to length
	# and also weighted by relative vel
	var relative_vel = target.linear_velocity - body.linear_velocity
	var d = relative_damp * relative_vel / length
	
	#var d = -constant_damp * towards / length
	
	var impulse = k * towards.normalized() * max_translation_impulse
	
	if debug: print("DISTANCE: ", length)
	if debug: print("IMPULSE: ", impulse.length())
	if debug: print("D: ", d.length())
	
	body.apply_central_impulse(impulse)
	body.apply_central_impulse(d)
	
	# wheee
	if recoil_body != null:
		if central_recoil:
			recoil_body.apply_central_impulse(-impulse)
			recoil_body.apply_central_impulse(-d)
		else:
			var pos = (body.global_position - recoil_body.global_position) \
											/ recoil_torque_reduction
			recoil_body.apply_impulse(-impulse, pos)
			recoil_body.apply_impulse(-d, pos)
