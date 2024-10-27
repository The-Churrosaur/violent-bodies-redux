
## use like a raycast - call predict() then read vars.
## contains junk data if you don't call predict first

class_name LeadComputer
extends Node


@export var launching_body : RigidBody3D
@export var muzzle_reference : Node3D
@export var projectile_velocity : float
@export var gravity : Vector3 = Vector3.DOWN
@export var collision_error = 1.0

@onready var aiming_raycast = %AimingRaycast
@onready var aim_point_area = %AimPointArea



func set_weapon(_projectile_velocity : float, _muzzle_reference : Node3D):
	muzzle_reference = _muzzle_reference
	projectile_velocity = _projectile_velocity


## returns global collision point or null
func predict(enemy_body : PhysicsBody3D):
	
	var e0 = enemy_body.global_position
	var p0 = muzzle_reference.global_position
	
	var ev
	if enemy_body is RigidBody3D : ev = enemy_body.linear_velocity
	else : ev = Vector3.ZERO
	
	# account for launching velocity
	ev = ev - launching_body.linear_velocity
	
	var pv = -muzzle_reference.global_basis.z * projectile_velocity
	
	var collision_time = 0.0
	var last_error = null
	var collision_point = null
	var delta = get_physics_process_delta_time()
	
	for i in range(100):
		var current_time = i * delta
		var e_current = e0 + ev * current_time
		var p_dir = e_current - p0
		var p_current = p0 + (p_dir.normalized() * current_time * projectile_velocity)
		var e_p = e_current - p_current
		
		#$MeshInstance3D.global_position = e_current
		#$MeshInstance3D2.global_position = p_current
		# if error increases over time, return no solution
		var current_error = e_p.length_squared()
		if last_error != null and last_error < current_error: 
			print("collision error increasing, no solution")
			return null
		last_error = current_error
		
		# mark time if error is under threshold
		if current_error <= collision_error * collision_error:
			collision_time = current_time
			#print("solution found: ", collision_time)
			collision_point = e_current
			break
	
	if collision_time <= 0: 
		#print("solution fully iterated...")
		return null
	
	return collision_point


## will get position of projectile in N seconds. 
func get_time_lead(time : float) -> Vector3:
	
	var ticks = time / get_physics_process_delta_time()
	
	var pos = muzzle_reference.global_transform.basis.y * projectile_velocity * time
	
	pos = pos + muzzle_reference.global_position
	pos = (1/2 * gravity * time * time) + pos
	#pos = (launching_body.linear_velocity * time / 10) + pos
	
	#print(pos)
	
	return pos

func check_aim(aim_point):
	if aim_point == null: return false
	
	aiming_raycast.global_transform = muzzle_reference.global_transform
	aim_point_area.global_position = aim_point
	
	aiming_raycast.force_raycast_update()
	return aiming_raycast.is_colliding()
	
