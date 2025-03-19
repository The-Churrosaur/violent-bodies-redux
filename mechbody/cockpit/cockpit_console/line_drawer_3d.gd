
@tool

class_name LineDrawer3D
extends MeshInstance3D

@export var points : Array[Vector3]
@export var color : Color
@export var draw_every_frame = false


func _process(delta):
	if draw_every_frame: draw()


func draw():
	
	# prep surface array
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	# vertex array
	var verts = PackedVector3Array()
	for point in points:
		verts.append(point + global_position)
	
	# color array
	var colors = PackedColorArray()
	colors.resize(verts.size())
	colors.fill(color)
	
	# normals?
	var normals = PackedVector3Array()
	normals.resize(verts.size())
	normals.fill(Vector3.UP)
	
	# fill surface array
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_COLOR] = colors
	
	# call
	mesh.clear_surfaces()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, surface_array)
