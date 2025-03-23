
class_name MyMeshSlicer
extends Node3D


@export var plane : Plane
@export var cap_uv = Vector2.ZERO
@export var cap_material : Material
@export var epsilon = 0.0001

@export var capper : MeshSlicerCapper


var markers = []



## takes plane in local coordinates
func slice(mesh_instance : MeshInstance3D, plane : Plane = self.plane, caps = true):
	
	#print("slicin! ", mesh_instance, plane, caps)
	
	# arraymeshes
	
	var arraymesh_upper = ArrayMesh.new()
	var arraymesh_lower = ArrayMesh.new()
	
	# store intersection points for later (cap filling)
	
	var intersections = {}
	var num_intersections = 0
	var intersection_sum = Vector3.ZERO
	
	# cycle through mesh surfaces in mesh
	
	for surface in range(mesh_instance.mesh.get_surface_count()): 
		
		# build tris into here
		
		var upper_surface_builder = SurfaceArrayBuilder.new()
		var lower_surface_builder = SurfaceArrayBuilder.new()
		
		
		# *sigh* I guess an mdt is necessary to get triangles without considering indices
		 
		var mdt = _create_mdt(mesh_instance.mesh, surface)
		
		
		# get vertex information  from surfacearray mesh
		
		var surface_array = mesh_instance.mesh.surface_get_arrays(surface)
		var verts = surface_array[Mesh.ARRAY_VERTEX]
		var uvs = surface_array[Mesh.ARRAY_TEX_UV]
		var normals = surface_array[Mesh.ARRAY_NORMAL]
		
		var num_verts = verts.size()
		
		#for i in range(verts.size()):
			#print("mdt vert: ", mdt.get_vertex(i))
			#print("arr vert: ", verts[i])
		
		
		# the actual tri pushing
		
		# iterate through tris (verts / 3 gives vert 0 of a new tri)
		
		for i in range(mdt.get_face_count()):
			
			
			# verts of this triangle
						
			#var v0 = i
			#var v1 = i + 1
			#var v2 = i + 2
			
			var v0 = mdt.get_face_vertex(i, 0)
			var v1 = mdt.get_face_vertex(i, 1)
			var v2 = mdt.get_face_vertex(i, 2)
			
			#print("ITERATING NEW TRIANGLE: ", i)
			#print(v0, ", ", v1, ", ", v2)
			
			
			# does this triangle sit nicely on one sice or the other?
			
			var tri_intersect = _tri_plane_intersection(verts[v0], verts[v1], verts[v2], plane)
			
			
			# push non-intersecting tris into correct surface
			# assume surface array order == winding order? # TODO
			
			if tri_intersect > 0: 
				#print("building upper: ")
				#print(upper_surface_builder.verts.size())
				
				upper_surface_builder.add_vert_manual(verts[v0], uvs[v0], normals[v0])
				upper_surface_builder.add_vert_manual(verts[v1], uvs[v1], normals[v1])
				upper_surface_builder.add_vert_manual(verts[v2], uvs[v2], normals[v2])
				pass
				
				
			if tri_intersect < 0: 
				#print("building lower:")
				#print(lower_surface_builder.verts.size())
				
				lower_surface_builder.add_vert_manual(verts[v0], uvs[v0], normals[v0])
				lower_surface_builder.add_vert_manual(verts[v1], uvs[v1], normals[v1])
				lower_surface_builder.add_vert_manual(verts[v2], uvs[v2], normals[v2])
				pass
			
			# slice intersecting tris
			
			if tri_intersect == 0: 
				
				#continue
				
				# (edges, intersecting vertices, vertices)
				var ab = null
				var ac = null
				
				var vab
				var vac
				
				var vab_norm
				var vac_norm
				var vab_uv
				var vac_uv
				
				var a
				var b
				var c
				
				
				# get ABC from verts
				
				# get face index organized arrays of vertex signs (above or below plane)
				# and face index organized array of vertex(indices) (for wraparound)
				
				var vert_array = [v0, v1, v2]
				var vert_signs = [sign(plane.distance_to(verts[v0])),
								  sign(plane.distance_to(verts[v1])),
								  sign(plane.distance_to(verts[v2])),]
				
				
				# iterate through vert array, if both neighbors are equal, vert is A
				
				# index of a in vert_array ( for getting b and c once a is found)
				var a_i = 0
				
				for vert_i in vert_array.size():
					if vert_signs[vert_i - 2] == vert_signs[vert_i - 1]: 
						a = vert_array[vert_i]
						a_i = vert_i
				
				# edge case, -1 0 1, no a is chosen: just choose one
				
				if !a: a = vert_array[a_i]
				
				# assume clockwise assignment - assign next vertex as C, prev as B (why did I do it this way?)
				
				c = vert_array[a_i - 2]
				b = vert_array[a_i - 1]
				
				#print("ABC ASSIGNED: ")
				#print("a: ", a)
				#print("b: ", b)
				#print("c: ", c)
				
				
				# get intersection vertices
				
				vab = plane.intersects_segment(verts[a], verts[b])
				vac = plane.intersects_segment(verts[a], verts[c])
				
				#vab = _plane_segment_intersection(plane, mdt.get_vertex(a), mdt.get_vertex(b))
				#vac = _plane_segment_intersection(plane, mdt.get_vertex(a), mdt.get_vertex(c))
				
				#if !vab or !vac : 
					#print("vabvac is null: ", a,b,c)
					#print(plane.distance_to(mdt.get_vertex(a)))
					#print(plane.distance_to(mdt.get_vertex(b)))
					#print(plane.distance_to(mdt.get_vertex(c)))
				
				# tip (a) positive or base positive
				
				var a_facing = sign(plane.distance_to(verts[a]))
				
				# interpolate normal/uv for vab/vac
				
				var vab_d = verts[a].distance_to(vab) / verts[a].distance_to(verts[b])
				var vac_d = verts[a].distance_to(vac) / verts[a].distance_to(verts[b])
				
				vab_norm = normals[a].lerp(normals[b], vab_d)
				vac_norm = normals[a].lerp(normals[c], vac_d)
				
				vab_uv = uvs[a].lerp(uvs[b], vab_d)
				vac_uv = uvs[a].lerp(uvs[c], vac_d)
				
				# populate intersections dict
				
				intersections[num_intersections] = [vab, vac, vab_uv, vac_uv]
				num_intersections += 1
				intersection_sum += vab + vac
				
				
				# make new triangles from split (choose vab as quad bisecting vertex) 
				
				# build tip triangle (upper or lower)
				#print("building tip tri")
				
				if a_facing > 0:
					upper_surface_builder.add_vert_manual(verts[a], uvs[a], normals[a])
					upper_surface_builder.add_vert_manual(vac, vac_uv, vac_norm)
					upper_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
				
				else:
					lower_surface_builder.add_vert_manual(verts[a], uvs[a], normals[a])
					lower_surface_builder.add_vert_manual(vac, vac_uv, vac_norm)
					lower_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
				
				# build base triangle 1 - vab b c
				#print("building base tri")
				
				if a_facing < 0:
					upper_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
					upper_surface_builder.add_vert_manual(verts[c], uvs[c], normals[c])
					upper_surface_builder.add_vert_manual(verts[b], uvs[b], normals[b])
				
				else:
					lower_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
					lower_surface_builder.add_vert_manual(verts[c], uvs[c], normals[c])
					lower_surface_builder.add_vert_manual(verts[b], uvs[b], normals[b])
				
				# build base triangle 2 - vab vac c
				#print("building base tri 2")
				
				if a_facing < 0:
					upper_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
					upper_surface_builder.add_vert_manual(vac, vac_uv, vac_norm)
					upper_surface_builder.add_vert_manual(verts[c], uvs[c], normals[c])
				
				else:
					lower_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
					lower_surface_builder.add_vert_manual(vac, vac_uv, vac_norm)
					lower_surface_builder.add_vert_manual(verts[c], uvs[c], normals[c])
		
		
		# populate arraymesh with this surface (if surface has verts to add)
		
		if !upper_surface_builder.is_empty(): 
			arraymesh_upper.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, upper_surface_builder.build())
		else: print("surface : ", surface, ", upper surface builder is empty")
		if !lower_surface_builder.is_empty(): 
			arraymesh_lower.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, lower_surface_builder.build())
		else: print("surface : ", surface, ", lower surface builder is empty")
	
	
	# check if both surfaces got filled
	
	if arraymesh_lower.get_surface_count() <= 0 or arraymesh_upper.get_surface_count() <= 0:
		print("arrymesh has no surfaces, returning: ")
		return null
	
	# create mesh instances
	
	var upper_meshinstance = _create_mesh_instance(arraymesh_upper, mesh_instance)
	var lower_meshinstance = _create_mesh_instance(arraymesh_lower, mesh_instance)
	
	# color meshes (surface override for base material)
	
	upper_meshinstance.set_surface_override_material(0, mesh_instance.get_surface_override_material(0))
	lower_meshinstance.set_surface_override_material(0, mesh_instance.get_surface_override_material(0))
	
	
	# return meshes,
	# return intersections for outside cap behavior
	
	return [lower_meshinstance, upper_meshinstance, intersections]



# -- PLANE MATH / HELPERS 



# returns positive, negative or zero
func _tri_plane_intersection(a : Vector3, b : Vector3, c : Vector3, plane : Plane) -> int:
	
	var a_dist = plane.distance_to(a)
	var b_dist = plane.distance_to(b)
	var c_dist = plane.distance_to(c)
	
	#print("triplane distances: ", a_dist, ", ", b_dist, ", ", c_dist)
	
	# if touching, still counts
	
	#print("evaluating new tri intersection... ", a, b, c)
	if absf(a_dist) < epsilon: 
		#print("zero approx: ", a_dist)
		a_dist = 0; 
	if absf(b_dist) < epsilon: 
		#print("zero approx: ", b_dist)
		b_dist = 0
	if absf(c_dist) < epsilon: 
		#print("zero approx: ", c_dist)
		c_dist = 0
	
	
	if a_dist <= 0 and b_dist <= 0 and c_dist <= 0 : return -1
	elif a_dist >= 0 and b_dist >= 0 and c_dist >= 0 : return  1 
	
	
	return 0


func _plane_segment_intersection(plane : Plane, a : Vector3, b : Vector3):
	
	var ray_normal = (b - a)
	var ray_origin = a
	
	var dot_normals = ray_normal.dot(plane.normal)
	
	# ray and plane are orthogonal (no intersection)
	
	if is_zero_approx(dot_normals): 
		print("dot normals zero")
		return null
	
	# intersection calculation
	
	var t = -(ray_origin.dot(plane.normal) - plane.d) / dot_normals
	if is_zero_approx(t) : 
		print("t approx zero")
		return null
	
	# intersect is not within segment
	
	#if (t * t) > (b - a).length_squared() :
		#print("t longer than segment: ", t, ", ", (b - a).length())
		#return null
	
	print(t)
	
	# return intersect
	
	return a + ray_normal * t


# -- ARRAYMESH / MESHINSTANCE / MDT


# populate mdt from mesh or primitive -> arraymesh

func _create_mdt(mesh : Mesh, surface : int) -> MeshDataTool:
	
	var mdt = MeshDataTool.new()
	
	if mesh is PrimitiveMesh:
		var array_mesh = ArrayMesh.new()
		array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh.get_mesh_arrays())
		mdt.create_from_surface(array_mesh, surface)
	else:
		mdt.create_from_surface(mesh, surface)
		
	return mdt


func _create_mesh_instance(mesh : Mesh, old_instance : MeshInstance3D):
	
	var meshinstance_new = MeshInstance3D.new()
	meshinstance_new.mesh = mesh
	#meshinstance_new.set_surface_override_material(0, old_instance.get_surface_override_material(0))
	#meshinstance_new.set_surface_override_material(1, old_instance.get_surface_override_material(0))

	return meshinstance_new
