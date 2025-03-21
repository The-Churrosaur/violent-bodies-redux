
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
		
		# mdt
		
		var mdt = _create_mdt(mesh_instance.mesh, surface)
		
		
		#var surface_array = mesh_instance.mesh.surface_get_arrays(surface)
		#var verts = surface_array[Mesh.ARRAY_VERTEX]
		#var uvs = surface_array[Mesh.ARRAY_TEX_UV]
		#var normals = surface_array[Mesh.ARRAY_NORMAL]
		#
		#var num_verts = verts.size()
		
		
		# the actual tri pushing
		
		# iterate through tris
		
		for i in range(mdt.get_face_count()):
			
			var tri_intersect = _tri_plane_intersection(mdt, i, plane)
			
			# push non-intersecting tris into correct surface
			
			if tri_intersect > 0: 
				#print("building upper")
				upper_surface_builder.add_tri_from_mdt(mdt, i)
			if tri_intersect < 0: 
				#print("building lower")
				lower_surface_builder.add_tri_from_mdt(mdt, i)
			
			# slice intersecting tris
			
			if tri_intersect == 0: 
				
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
				
				var vert_signs = []
				var vert_array = []
				vert_array.resize(3)
				vert_signs.resize(3)
				
				
				for vert_i in range(3):
					var vert_index = mdt.get_face_vertex(i, vert_i)
					var vert = mdt.get_vertex(vert_index)
					
					vert_array[vert_i] = vert_index
					vert_signs[vert_i] = sign(plane.distance_to(vert))
				
				#print("iterating face...", vert_array, vert_signs)
				
				# iterate through vert array, if both neighbors are equal, vert is A
				
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
				
				#if !a or !b or !c: 
				#print("ABC is null?: ")
				#mdt.get_vertex(a)
				#mdt.get_vertex(b)
				#mdt.get_vertex(c)
				
				
				# get intersection vertices
				
				vab = plane.intersects_segment(mdt.get_vertex(a), mdt.get_vertex(b))
				vac = plane.intersects_segment(mdt.get_vertex(a), mdt.get_vertex(c))
				
				#vab = _plane_segment_intersection(plane, mdt.get_vertex(a), mdt.get_vertex(b))
				#vac = _plane_segment_intersection(plane, mdt.get_vertex(a), mdt.get_vertex(c))
				
				if !vab or !vac : 
					print("vabvac is null: ", a,b,c)
					print(plane.distance_to(mdt.get_vertex(a)))
					print(plane.distance_to(mdt.get_vertex(b)))
					print(plane.distance_to(mdt.get_vertex(c)))
				
				# tip (a) positive or base positive
				
				var a_facing = sign(plane.distance_to(mdt.get_vertex(a)))
				
				# interpolate normal/uv for vab/vac
				
				var vab_d = mdt.get_vertex(a).distance_to(vab) / mdt.get_vertex(a).distance_to(mdt.get_vertex(b))
				var vac_d = mdt.get_vertex(a).distance_to(vac) / mdt.get_vertex(a).distance_to(mdt.get_vertex(c))
				
				vab_norm = mdt.get_vertex_normal(a).lerp(mdt.get_vertex_normal(b), vab_d)
				vac_norm = mdt.get_vertex_normal(a).lerp(mdt.get_vertex_normal(c), vac_d)
				
				vab_uv = mdt.get_vertex_uv(a).lerp(mdt.get_vertex_uv(b), vab_d)
				vac_uv = mdt.get_vertex_uv(a).lerp(mdt.get_vertex_uv(c), vac_d)
				
				# populate intersections dict
				
				intersections[num_intersections] = [vab, vac, vab_uv, vac_uv]
				num_intersections += 1
				intersection_sum += vab + vac
				
				
				# make new triangles from split (choose vab as quad bisecting vertex) 
				
				# build tip triangle (upper or lower)
				
				if a_facing > 0:
					upper_surface_builder.add_vert_from_mdt(mdt, a)
					upper_surface_builder.add_vert_manual(vac, vac_uv, vac_norm)
					upper_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
				
				else:
					lower_surface_builder.add_vert_from_mdt(mdt, a)
					lower_surface_builder.add_vert_manual(vac, vac_uv, vac_norm)
					lower_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
				
				# build base triangle 1 - vab b c
				
				if a_facing < 0:
					upper_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
					upper_surface_builder.add_vert_from_mdt(mdt, c)
					upper_surface_builder.add_vert_from_mdt(mdt, b)
				
				else:
					lower_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
					lower_surface_builder.add_vert_from_mdt(mdt, c)
					lower_surface_builder.add_vert_from_mdt(mdt, b)
				
				# build base triangle 2 - vab vac c
				
				if a_facing < 0:
					upper_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
					upper_surface_builder.add_vert_manual(vac, vac_uv, vac_norm)
					upper_surface_builder.add_vert_from_mdt(mdt, c)
				
				else:
					lower_surface_builder.add_vert_manual(vab, vab_uv, vab_norm)
					lower_surface_builder.add_vert_manual(vac, vac_uv, vac_norm)
					lower_surface_builder.add_vert_from_mdt(mdt, c)
		
		
		# populate arraymesh with this surface (if surface has verts to add)
		
		if !upper_surface_builder.is_empty(): 
			arraymesh_upper.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, upper_surface_builder.build())
		if !lower_surface_builder.is_empty(): 
			arraymesh_lower.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, lower_surface_builder.build())
	
	
	# check if any surfaces got filled
	
	if arraymesh_lower.get_surface_count() <= 0:
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
func _tri_plane_intersection(mdt : MeshDataTool, tri_index : int, plane : Plane) -> int:
	
	var a = mdt.get_vertex(mdt.get_face_vertex(tri_index, 0))
	var b = mdt.get_vertex(mdt.get_face_vertex(tri_index, 1))
	var c = mdt.get_vertex(mdt.get_face_vertex(tri_index, 2))
	
	var a_dist = plane.distance_to(a)
	var b_dist = plane.distance_to(b)
	var c_dist = plane.distance_to(c)
	
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
