extends Node


func _physics_process(delta: float) -> void:
	
	#check_children(self)
	
	pass


func check_children(node):
	for n in node.get_children():
		if n.get("global_transform"):
			if !n.global_transform.is_finite(): 
				print("Nan found: ", n, ", ", n.get_class())
				return
		check_children(n)
	
