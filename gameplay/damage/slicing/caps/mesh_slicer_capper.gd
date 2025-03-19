class_name MeshSlicerCapper
extends Node3D


@export var cap_material : Material
@export var centroid_calc = true


func cap(intersections : Dictionary, plane : Plane,
		 upper_mesh : MeshInstance3D, lower_mesh : MeshInstance3D):
	
	_flat_cap(intersections, plane, upper_mesh, lower_mesh)



func _flat_cap(intersections : Dictionary, plane : Plane, 
			   upper_mesh_instance : MeshInstance3D, lower_mesh_instance : MeshInstance3D):
	
	
	# arraymesh builders
	
	var upper_mesh = upper_mesh_instance.mesh
	var lower_mesh = lower_mesh_instance.mesh
	
	var upper_cap_builder = SurfaceArrayBuilder.new()
	var lower_cap_builder = SurfaceArrayBuilder.new()
	
	
	# get average of intersections and average UV
	
	var intersection_sum = Vector3.ZERO
	var uv_sum = Vector2.ZERO
	
	for pair in intersections.values():
		intersection_sum += pair[0] + pair[1]
		uv_sum += pair[2] + pair[3]
	
	var intersection_com = intersection_sum / intersections.size()
	var cap_uv = uv_sum / intersections.size()
	
	
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
		
		intersection_com = centroid_sum / intersections.size() 
	
	
	# iterate through intersection pairs and create triangles
	# use plane normal and cap_uv
	
	for pair in intersections.values():
		
		var vab = pair[0]
		var vac = pair[1]
		var vab_uv = pair[2]
		var vac_uv = pair[3]
		
		
		# create upper triangles
		
		# if new face normal is opposite desired normal, flip it
		# hacky - there is probably an analytical solution 
		
		var cross = (vab - intersection_com).cross(vac  - intersection_com)
		
		var upper_normal = -plane.normal
		if cross.dot(upper_normal) >= 0: 
			upper_cap_builder.add_vert_manual(intersection_com, cap_uv, upper_normal)
			upper_cap_builder.add_vert_manual(vac, vac_uv, upper_normal)
			upper_cap_builder.add_vert_manual(vab, vab_uv, upper_normal)
		else:
			upper_cap_builder.add_vert_manual(intersection_com, cap_uv, upper_normal)
			upper_cap_builder.add_vert_manual(vab, vab_uv, upper_normal)
			upper_cap_builder.add_vert_manual(vac, vac_uv, upper_normal)
		
		
		# create lower triangles
		
		var lower_normal = plane.normal
		if cross.dot(lower_normal) >= 0:
			lower_cap_builder.add_vert_manual(intersection_com, cap_uv, lower_normal)
			lower_cap_builder.add_vert_manual(vac, vac_uv, lower_normal)
			lower_cap_builder.add_vert_manual(vab, vab_uv, lower_normal)
		else:
			lower_cap_builder.add_vert_manual(intersection_com, cap_uv, lower_normal)
			lower_cap_builder.add_vert_manual(vab, vab_uv, lower_normal)
			lower_cap_builder.add_vert_manual(vac, vac_uv, lower_normal)
	
	
	# check for no verts (tiny cut)
	
	if upper_cap_builder.is_empty() or lower_cap_builder.is_empty(): return
	#if upper_cap_builder.verts.size() <= 1 or lower_cap_builder.verts.size() <= 1: return
	
	
	# if multiple surfaces, appends/replaces last one 
	# (don't add like a million surfaces over multiple slices)
	
	if upper_mesh.get_surface_count() > 1: 
		upper_cap_builder.append_surface(upper_mesh, upper_mesh.get_surface_count() - 1)
		upper_mesh.surface_re
	 
	
	# build new geo onto existing arraymeshes (new surface)
	
	upper_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, upper_cap_builder.build())
	lower_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, lower_cap_builder.build())
	
	
	# apply material to new surface
	
	upper_mesh.surface_set_material(upper_mesh.get_surface_count() - 1, cap_material)
	lower_mesh.surface_set_material(lower_mesh.get_surface_count() - 1, cap_material)
