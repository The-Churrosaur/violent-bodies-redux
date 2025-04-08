## detects damage_area, communicate with health

class_name Hurtbox
extends Area3D


@export var health : HealthModule


func _on_area_entered(area: Area3D) -> void:
	#print("area entered hurtbox: ", area)
	if area is DamageArea: 
		_damage(area)
		area.hit()


func _damage(hitbox : DamageArea):
	#print("hurtbox being hurt")
	if health: health.change_health(-hitbox.damage)
