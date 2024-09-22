
## use like a raycast - call predict() then read vars.
## contains junk data if you don't call predict first

class_name LeadComputer
extends Node


@export var launching_body : RigidBody3D
@export var muzzle_reference : Node3D
@export var projectile_velocity : float
@export var gravity : Vector3 = Vector3.DOWN

@onready var aiming_raycast = %AimingRaycast
@onready var aim_point_area = %AimPointArea


# TODO make these a dict that's returned or something
## these fields are set when calling predict()
var collision_time : float
var collision_point : Vector3
var aim_point : Vector3
var aimed = false



func set_weapon(_projectile_velocity : float, _muzzle_reference : Node3D):
	muzzle_reference = _muzzle_reference
	projectile_velocity = _projectile_velocity


func predict(enemy_body : PhysicsBody3D):
	
	var e0 = enemy_body.global_position
	var p0 = muzzle_reference.global_position
	var delta0 = p0.distance_to(e0)
	
	var ev
	if enemy_body is RigidBody3D : ev = enemy_body.linear_velocity.length()
	else : ev = 0
	
	var pv = projectile_velocity
	
	collision_time = delta0 / abs(pv - ev)
	collision_point = enemy_body.linear_velocity * collision_time + e0
	
	# 'aim point' is the collision point minus displacement due to inherited vel
	# the remaining displacement is how the projetile travels in the reference
	# frame of the shooter
	
	var body_displacement = launching_body.linear_velocity * collision_time / 10
	#aim_point = p0 + (collision_point - body_displacement) 
	aim_point = collision_point - body_displacement
	
	aimed = _check_aim()


## will get position of projectile in N seconds. 
func get_time_lead(time : float) -> Vector3:
	
	var ticks = time / get_physics_process_delta_time()
	
	var pos = muzzle_reference.global_transform.basis.y * projectile_velocity * time
	
	pos = pos + muzzle_reference.global_position
	pos = (1/2 * gravity * time * time) + pos
	pos = (launching_body.linear_velocity * time / 10) + pos
	
	#print(pos)
	
	return pos

func _check_aim():
	
	aiming_raycast.global_transform = muzzle_reference.global_transform
	aim_point_area.global_position = aim_point
	
	aiming_raycast.force_raycast_update()
	return aiming_raycast.is_colliding()
	
