
# area to interact with a sliceable

class_name SlicerArea
extends Area3D


# for determining swing
@export var base : Marker3D
@export var tip : Marker3D

@export var cooldown = 1.0

var last_position := Vector3.ZERO
var velocity := Vector3.ZERO

var on_cooldown = false


func _on_body_entered(body: Node3D) -> void:
	
	if on_cooldown: 
		print("slicer on cooldown")
		return
	
	if body is SliceableBody:
		
		print("slicer entered slicearea")
		
		var plane_vec = (tip.global_position - base.global_position).cross(velocity)
		
		print("plane vec: ", plane_vec)
		
		body.slice(plane_vec, tip.global_position)
		
		on_cooldown = true
		await get_tree().create_timer(cooldown).timeout
		on_cooldown = false


func _physics_process(delta: float) -> void:
	velocity = global_position - last_position
	last_position = global_position
