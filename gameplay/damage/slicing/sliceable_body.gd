
class_name SliceableBody
extends RigidBody3D


# TODO recursive slicing doesn't work with separate caps


@export_group("Parameters")

@export var create_collision_on_slice = true
@export var collision_convex_hulls = 10
@export var physics_push = 100
@export var physics_torque = 0.2
@export var recursive_sliceable = true
@export var recursive_packed : PackedScene = preload("res://gameplay/damage/slicing/sliceable_body.tscn")

@export_group("Components")

@export var meshinstance : MeshInstance3D
@export var slicer : MyMeshSlicer
@export var capper : MeshSlicerCapper



func _ready() -> void:
	
	await get_tree().create_timer(5.0).timeout
	
	var random_vec = Vector3(randf(), randf(), randf())
	
	slice(Plane(random_vec, 2))



func slice(plane : Plane):
	
	# slice (and check first)
	
	var slice = slicer.slice(meshinstance, plane)
	
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
	
	# cleanup
	queue_free()


# gets collision shapes from meshinstance3d, adds to body
func _set_collision_shapes(meshinstance : MeshInstance3D, body : RigidBody3D):
	
	var decomp_settings = MeshConvexDecompositionSettings.new()
	decomp_settings.max_convex_hulls = collision_convex_hulls
	
	meshinstance.create_multiple_convex_collisions(decomp_settings)
	
	var staticbody = meshinstance.get_child(0)
	var shapes = staticbody.get_children()
	
	for shape in shapes:
		body.add_child(shape)
	
	staticbody.queue_free()
