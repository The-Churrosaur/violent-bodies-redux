class_name MeshSlicerCapper
extends Node3D


@export var cap_material : Material
@export var centroid_calc = false


func cap(intersections : Dictionary, plane : Plane,
		 upper_mesh : MeshInstance3D, lower_mesh : MeshInstance3D):
	
	#_flat_cap(intersections, plane, upper_mesh, lower_mesh)
	_ring_caps(intersections, plane, upper_mesh, lower_mesh)



func _flat_cap(intersections : Dictionary, plane : Plane, 
			   upper_mesh_instance : MeshInstance3D, lower_mesh_instance : MeshInstance3D):
	
	# arraymesh builders
	
	var upper_mesh = upper_mesh_instance.mesh
	var lower_mesh = lower_mesh_instance.mesh
	
	var upper_cap_builder = SurfaceArrayBuilder.new()
	var lower_cap_builder = SurfaceArrayBuilder.new()
	
	
	# build faces
	
	_populate_flat_cap_vertices(intersections, upper_cap_builder, -plane.normal)
	_populate_flat_cap_vertices(intersections, lower_cap_builder, plane.normal)
	
	
	# check for no verts (tiny cut)
	
	if upper_cap_builder.is_empty() or lower_cap_builder.is_empty(): return	
	
	
	# build new geo onto existing arraymeshes (new surface)
	
	upper_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, upper_cap_builder.build())
	lower_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, lower_cap_builder.build())
	
	
	# apply material to mesh
	
	_set_mesh_material(upper_mesh)
	_set_mesh_material(lower_mesh)


# traverse edges to find rings, fill each ring as a flat cap
# still will not work with concave rings
func _ring_caps(intersections : Dictionary, plane : Plane, 
				upper_mesh_instance : MeshInstance3D, lower_mesh_instance : MeshInstance3D):
	
	
	# arraymesh builders
	
	var upper_mesh = upper_mesh_instance.mesh
	var lower_mesh = lower_mesh_instance.mesh
	
	var upper_cap_builder = SurfaceArrayBuilder.new()
	var lower_cap_builder = SurfaceArrayBuilder.new()
	
	
	# ring time
	
	# create working copy of intersections
	
	var unmatched_intersections = intersections.duplicate()
	
	#print("PRINTING ALL UNMATCHED INTERSECTIONS: ")
	#for i in unmatched_intersections.values(): print(i[0], i[1])
	
	# while unmatched intersections still has values, find rings
	
	while !unmatched_intersections.is_empty():
		
		#print(unmatched_intersections.size()," unmatched intersections still exist, building ring...")
		
		# ring dict mirrors intersection dict
		
		var ring = {}
		
		# get first value
		
		var pair = unmatched_intersections.keys()[0]
		
		# while pair exists, add to ring, remove from unmatched, and find next pair
		
		while pair != null:
			
			#print("ring value found, adding: ", pair)
			
			ring[pair] = unmatched_intersections[pair]
			unmatched_intersections.erase(pair)
			pair = _find_next_ring_pair(ring[pair], unmatched_intersections)
		
		#print("no additional pair found, building ring: ")
		
		# build ring
		
		_populate_flat_cap_vertices(ring, upper_cap_builder, -plane.normal)
		_populate_flat_cap_vertices(ring, lower_cap_builder, plane.normal)
	
	
	# build new geo onto existing arraymeshes (new surface)
	
	upper_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, upper_cap_builder.build())
	lower_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, lower_cap_builder.build())
	
	
	# apply material to mesh
	
	_set_mesh_material(upper_mesh)
	_set_mesh_material(lower_mesh)


# finds another edge that touches this edge (pair) or null
func _find_next_ring_pair(pair : Array, search_intersections: Dictionary):
	
	var a = pair[0]
	var b = pair[1]
	
	# searches dict for any pair that also contains a or b
	# order doesn't matter since we're removing items (prevents looping)
	
	for i in search_intersections.keys():
		var i_a = search_intersections[i][0]
		var i_b = search_intersections[i][1]
		
		
		if (Utils.compare_vectors(a, i_a) or Utils.compare_vectors(a, i_b) or
			Utils.compare_vectors(b, i_a) or Utils.compare_vectors(b, i_b)):
			
			#print("next value found: ")
			#print("old: ", pair[0], pair[1])
			#print("new: ", search_intersections[i][0], search_intersections[i][1])
			
			return i
	
	# given dict does not contain next pair
	
	return null



# the vert pushing
func _populate_flat_cap_vertices(intersections : Dictionary, builder : SurfaceArrayBuilder, normal : Vector3):
	
	# get average of intersections and average UV
	
	var intersection_sum = Vector3.ZERO
	var uv_sum = Vector2.ZERO
	
	for pair in intersections.values():
		intersection_sum += pair[0] + pair[1]
		uv_sum += pair[2] + pair[3]
	
	var intersection_com = intersection_sum / (intersections.size() * 2)
	var cap_uv = uv_sum / (intersections.size() * 2)
	
	
	# try to get centroid of shape instead of COM
	
	if centroid_calc:
		
		var centroid_sum = Vector3.ZERO
		
		# iterate through tris
		
		for pair in intersections.values():
			var a = intersection_com
			var b = pair[0]
			var c = pair[1]
			var area = (a - b).cross(a - c).length() / 2
			
			centroid_sum += (b * area) + (c * area)
		
		intersection_com = centroid_sum / (intersections.size() * 2) 
	
	
	# iterate through intersection pairs and create triangles
	# use plane normal and cap_uv
	
	for pair in intersections.values():
		
		var vab = pair[0]
		var vac = pair[1]
		var vab_uv = pair[2]
		var vac_uv = pair[3]
		
		
		# create triangles
		
		# build both sides of normals (elegant kludge for some being wrong + more) 

		builder.add_vert_manual(intersection_com, cap_uv, normal)
		builder.add_vert_manual(vac, vac_uv, normal)
		builder.add_vert_manual(vab, vab_uv, normal)

		builder.add_vert_manual(intersection_com, cap_uv, normal)
		builder.add_vert_manual(vab, vab_uv, normal)
		builder.add_vert_manual(vac, vac_uv, normal)


# applies material to all mesh surfaces
func _set_mesh_material(mesh : Mesh, material = cap_material):
	for i in range(mesh.get_surface_count()):
		mesh.surface_set_material(i, material)
