
class_name SliceableBody
extends RigidBody3D


@export_group("Parameters")

@export var create_collision_on_slice = false
#@export var collision_convex_hulls = 1
@export var physics_push = 10
@export var physics_torque = 0.01
@export var recursive_sliceable = true
@export var recursive_packed : PackedScene = preload("res://gameplay/damage/slicing/sliceable_body.tscn")

@export_group("Components")

@export var meshinstance : MeshInstance3D
@export var slicer : MyMeshSlicer
@export var capper : MeshSlicerCapper


var iteration = 0


func _ready() -> void:
	
	
	#while true:
		
	await get_tree().create_timer(1.0).timeout
	#await get_tree().get_frame()
	
	randomize()
	var random_vec = Vector3(randf(), randf(), randf())
	#random_vec = Vector3(0.234875893, 1, -1)
	
	if iteration < 1:
		slice(random_vec, global_position)
	
	
	pass



func slice(slice_normal : Vector3, slice_point : Vector3):
	
	var start_time = Time.get_ticks_msec()
	print("Start: ", start_time)
	print("vertices: ", meshinstance.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX].size())
	
	# slice (and check first)
	
	# convert plane from global to local
	
	var local_plane_normal = global_basis.inverse() * slice_normal
	var local_plane_center = to_local(slice_point)
	$MeshInstance3D.look_at($MeshInstance3D.global_position + local_plane_normal * 5, )
	$MeshInstance3D.position = local_plane_center
	var plane = Plane(local_plane_normal, local_plane_center)
	
	#await get_tree().create_timer(2.0).timeout
	
	
	var slice = slicer.slice(meshinstance, plane)
	
	#var slice = []
	#slice.resize(4)
	
	#var task_id = WorkerThreadPool.add_task(_slice_threaded.bindv([1, meshinstance, plane, slice]))
	#await get_tree().create_timer(0.5).timeout
	#print("task completed? ", WorkerThreadPool.is_task_completed(task_id))
	#WorkerThreadPool.wait_for_task_completion(task_id)
	
	
	#print("slice...: ", slice)
	if !slice : return
	
	var lower_mesh = slice[0]
	var upper_mesh = slice[1]
	var intersections = slice[2]
	
	
	# set up new bodies
	
	var upper_body : RigidBody3D
	var lower_body : RigidBody3D
	
	if recursive_sliceable: 
		upper_body = recursive_packed.instantiate()
		lower_body = recursive_packed.instantiate()
		upper_body.iteration = iteration + 1
		lower_body.iteration = iteration + 1
	else:
		upper_body = RigidBody3D.new()
		lower_body = RigidBody3D.new()
	
	add_sibling(upper_body)
	add_sibling(lower_body)
	
	upper_body.global_transform = global_transform
	lower_body.global_transform = global_transform
	
	
	# add sliced bits to bodies
	
	lower_body.add_child(lower_mesh)
	upper_body.add_child(upper_mesh)
	
	if lower_body is SliceableBody: lower_body.meshinstance = lower_mesh
	if upper_body is SliceableBody: upper_body.meshinstance = upper_mesh
	
	
	# cap
	
	capper.cap(intersections, plane, upper_mesh, lower_mesh)
	
	
	# collision
	
	if create_collision_on_slice:
		_set_collision_shapes(lower_mesh, lower_body)
		_set_collision_shapes(upper_mesh, upper_body)
	
	
	# physics push
	
	lower_body.apply_central_force(-plane.normal * physics_push)
	upper_body.apply_central_force(plane.normal * physics_push)
	
	lower_body.apply_torque_impulse(-plane.normal * physics_torque)
	upper_body.apply_torque_impulse(plane.normal * physics_torque)
	
	var random_vec = Vector3(randf(), randf(), randf())
	
	lower_body.apply_torque_impulse(random_vec * physics_torque)
	lower_body.apply_torque_impulse(-random_vec * physics_torque)
	
	print("FINISH: ", Time.get_ticks_msec() - start_time)
	
	
	# cleanup
	queue_free()


func _slice_threaded(meshinstance, plane, return_array):
	print("slice threaded called: ", meshinstance)
	return_array = slicer.slice(meshinstance, plane)


# gets collision shapes from meshinstance3d, adds to body
func _set_collision_shapes(meshinstance : MeshInstance3D, body : RigidBody3D):
	
	#var decomp_settings = MeshConvexDecompositionSettings.new()
	#decomp_settings.max_convex_hulls = collision_convex_hulls
	#
	#meshinstance.create_multiple_convex_collisions(decomp_settings)
	
	meshinstance.create_trimesh_collision()
	
	var staticbody = meshinstance.get_child(0)
	var shapes = staticbody.get_children()
	
	for shape in shapes:
		shape.reparent(body)
		#body.add_child(shape)
	
	staticbody.queue_free()
