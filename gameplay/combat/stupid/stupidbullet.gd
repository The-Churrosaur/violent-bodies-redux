extends RigidBody3D


@export var rotation_torque = 2.0

var launched_velocity : Vector3

# Called when the node enters the scene tree for the first time.
#func _ready():
	##apply_torque(transform.basis.x * rotation_torque)
	#pass

#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	##print(linear_velocity.length())
	#pass
#
#func _physics_process(delta):
	#position += (-basis.z * 500 * delta + launched_velocity * delta)


func _on_timer_timeout():
	_explode()
	pass


func _on_area_3d_area_entered(area):
	if area.is_in_group("laser"):
		linear_velocity = -linear_velocity
		position += linear_velocity * 0.01

func _on_body_entered(body):
	_explode()


func _explode():
	#freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	#freeze = true
	$Stupidbullet/MeshInstance3D.visible = false
	$hitFX.emitting = true


func _on_hit_fx_finished():
	queue_free()
