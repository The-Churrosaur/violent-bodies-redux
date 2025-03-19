## detects damage_area, communicate with health

extends Area3D


@export var health : HealthModule


func _on_area_entered(area: Area3D) -> void:
	if area is DamageArea: _damage(area)


func _damage(hitbox : DamageArea):
	if health: health.change_health(-hitbox.damage)
