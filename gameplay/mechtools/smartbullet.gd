class_name SmartBullet
extends Area3D

@export var bullet_velocity = 500
@export var damage = 10
@export var damage_area : DamageArea
@export var timer : Timer

@onready var mesh_instance_3d = $MeshInstance3D

var launch_velocity : Vector3


func enable():
	await get_tree().get_frame()
	monitoring = true
	monitorable = true
	mesh_instance_3d.visible = true
	timer.start()


func disable():
	monitorable = false
	monitoring = false
	mesh_instance_3d.visible = true
	timer.stop()


func _physics_process(delta):
	position += (-basis.z * bullet_velocity + launch_velocity) * delta


func _on_body_entered(body):
	_explode()


func _on_timer_timeout():
	_explode()


func _explode():
	$MeshInstance3D.visible = false
	#$hitFX.emitting = true


func _on_hit_fx_finished():
	disable()
