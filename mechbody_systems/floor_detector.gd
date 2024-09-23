
## for getting surface normal for skating

class_name FloorDetector
extends RayCast3D

@export var floor_normal_reference : Node3D
# assume this is a child

@onready var normal_lookat = $NormalLookat
@onready var normal_lookat_rotated = $NormalLookat/NormalLookatRotated



func _physics_process(delta):
	
	var normal = get_collision_normal()
	#normal_lookat.look_at(global_position + normal * 5)
	#floor_normal_reference.global_transform = normal_lookat_rotated.global_transform
	#floor_normal_reference.look_at(normal)
	
	var floor_basis = floor_normal_reference.global_basis
	
	floor_basis.y = normal
	floor_basis.x = floor_basis.y.cross(floor_basis.z)
	floor_normal_reference.global_basis = floor_basis.orthonormalized()
