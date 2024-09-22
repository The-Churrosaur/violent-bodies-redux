
## for getting surface normal for skating

class_name FloorDetector
extends RayCast3D

@export var floor_normal_reference : Node3D
# assume this is a child


func _physics_process(delta):
	var normal = get_collision_normal()
	floor_normal_reference.position = normal * 5
