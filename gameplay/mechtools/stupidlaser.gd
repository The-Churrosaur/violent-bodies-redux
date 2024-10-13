extends StupidGun
@onready var ray_cast_3d = $RayCast3D
@onready var laser = $"../laser"


func _set_projectile():
	
	print("firing laser")
	
	
	ray_cast_3d.force_raycast_update()
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		
		if collider is TrainingBot:
			collider._damage(100)
	
	laser.visible = true
	await get_tree().create_timer(0.02).timeout
	laser.visible = false
	pass
	
