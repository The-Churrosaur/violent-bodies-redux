
class_name SlicerAreaBigplane
extends Area3D


func check_slice(normal):
	for body in get_overlapping_bodies(): 
		if body is SliceableBody:
			body.slice(normal, global_position)
