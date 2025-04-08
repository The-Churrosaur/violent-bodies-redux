class_name PoolBullet
extends Node3D

@export var bullet_velocity = 500
@export var lifetime = 1.0

@onready var mesh_instance_3d = $MeshInstance3D
@onready var damage_area: DamageArea = $DamageArea

var launch_velocity : Vector3
var current_lifetime = 0.0
var disabled = false


func _ready() -> void:
	disable()


func enable():
	disabled = false
	#if !get_parent(): LevelGlobals.level.add_child(self)
	mesh_instance_3d.visible = true
	$DamageArea.monitorable = true
	
	current_lifetime = 0
	$hitFX.emitting = false


func disable():
	disabled = true
	$DamageArea.monitorable = false
	$MeshInstance3D.visible = false
	#get_parent().remove_child(self)


func set_damage(damage):
	damage_area.damage = damage


func _physics_process(delta):
	if disabled: return
	
	position += (-basis.z * bullet_velocity + launch_velocity) * delta
	
	current_lifetime += delta
	if current_lifetime > lifetime: 
		_explode()


func _explode():
	disable()
	$hitFX.restart()


func _on_damage_area_on_hit() -> void:
	_explode()


func _on_hit_fx_finished():
	pass
