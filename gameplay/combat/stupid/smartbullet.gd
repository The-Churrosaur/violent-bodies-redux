class_name SmartBullet
extends Area3D

@export var bullet_velocity = 500
@export var damage = 10
@export var damage_area : DamageArea
@export var lifetime = 1.0

@onready var mesh_instance_3d = $MeshInstance3D

var launch_velocity : Vector3
var current_lifetime = 0
var exploding = false


func enable():
	mesh_instance_3d.visible = true


func _physics_process(delta):
	if exploding: return
	
	position += (-basis.z * bullet_velocity + launch_velocity) * delta
	current_lifetime += delta
	if current_lifetime > lifetime: _explode()


func _explode():
	exploding = true
	$MeshInstance3D.visible = false
	$DamageArea.monitorable = false
	$hitFX.restart()


func _on_hit_fx_finished():
	queue_free()
