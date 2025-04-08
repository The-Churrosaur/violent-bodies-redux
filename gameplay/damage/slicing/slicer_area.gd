
# area to interact with a sliceable

class_name SlicerArea
extends Area3D

@export var cool_slicer : CoolSlicer

@export var enabled = false 

# for determining swing
@export var base : Marker3D
@export var tip : Marker3D

@export var cooldown = 1.0

@export var sword : Sword

var last_position := Vector3.ZERO
var velocity := Vector3.ZERO

## overrides normal discovery for next slice (for cool slice)
var force_normal = null

var on_cooldown = false


func _on_body_entered(body: Node3D) -> void:
	
	if !enabled : return
	
	if on_cooldown: 
		print("slicer on cooldown")
		return
	
	if body is SliceableBody:
		
		print("slicer entered slicearea")
		
		var plane_vec = (tip.global_position - base.global_position).cross(sword.velocity)
		
		if force_normal: 
			plane_vec = force_normal
			force_normal = null
		
		print("plane vec: ", plane_vec)
		
		body.slice(plane_vec, tip.global_position)
		
		#if !cool_slicer.slicing: cool_slicer.cool_slice()
		
		on_cooldown = true
		await get_tree().create_timer(cooldown).timeout
		on_cooldown = false
