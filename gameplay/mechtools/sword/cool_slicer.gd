
class_name CoolSlicer
extends Node3D


@export var sword : Sword
@export var slicer : SlicerArea
@export var mesh : Node3D
@export var mesh_sides : Node3D
@export var tip : Marker3D
@export var base : Marker3D

@onready var gpu_particles_3d: GPUParticles3D = $"../MeshInstance3D/GPUParticles3D"
@onready var slicer_area_bigplane: SlicerAreaBigplane = $"../SlicerAreaBigplane"
@onready var damage_area_bigplane: DamageArea = $"../SlicerAreaBigplane/DamageAreaBigplane"

var slicing = false


func cool_slice():
	
	#var scale_tween = create_tween()
	#scale_tween.tween_property(gpu_particles_3d,"scale", Vector3(1,100,1),0.1)
	#scale_tween.tween_property(gpu_particles_3d,"scale", Vector3(1,1,1),0.2)
	#
	#var pos_tween = create_tween()
	#pos_tween.tween_property(gpu_particles_3d, "position", Vector3(0,100,0), 0.1)
	#pos_tween.tween_property(gpu_particles_3d, "position", Vector3(0,1.3,0), 0.1)
	
	slicing = true
	
	Engine.time_scale = 0.2
	
	sword.grabbable_controller.controller.trigger_haptic_pulse("haptic", 5, 1, 0.1, 0)
	
	var slice_normal = (tip.global_position - base.global_position).cross(sword.velocity)
	
	slicer_area_bigplane.look_at(slicer_area_bigplane.global_position + slice_normal)
	slicer_area_bigplane.check_slice(slice_normal)
	
	print("DAMAGING OVERLAPPING AREAS")
	damage_area_bigplane.monitoring = true
	damage_area_bigplane.monitorable = true
	damage_area_bigplane.damage_overlapping_areas()
	
	
	mesh.look_at(mesh.global_position + slice_normal)
	mesh.reparent(LevelGlobals.level)
	mesh.global_position = base.global_position
	
	var blink_time =  0.01
	
	for i in 2:
		await get_tree().create_timer(randf_range(0, blink_time)).timeout
		mesh.visible = true
		#mesh_sides.visible = true
		await get_tree().create_timer(randf_range(0, blink_time)).timeout
		mesh.visible = false
		#mesh_sides.visible = false
		await get_tree().create_timer(randf_range(0, blink_time)).timeout
	
	damage_area_bigplane.monitoring = false
	damage_area_bigplane.monitorable = false
	
	mesh.visible = true
	await get_tree().create_timer(randf_range(0.1, 0.3)).timeout
	mesh.visible = false
	
	for i in 2:
		await get_tree().create_timer(randf_range(0, blink_time)).timeout
		mesh.visible = true
		await get_tree().create_timer(randf_range(0, blink_time)).timeout
		mesh.visible = false
		await get_tree().create_timer(randf_range(0, blink_time)).timeout
	
	Engine.time_scale = 1.0
	
	slicer.enabled = false
	
	var cooldown = 0.5
	
	await get_tree().create_timer(cooldown)
	
	slicing = false
