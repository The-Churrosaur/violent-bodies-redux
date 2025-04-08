
## aka hitbox
class_name DamageArea
extends Area3D

signal on_hit()

@export var damage = 1


func hit():
	on_hit.emit()


# TODO 
func damage_overlapping_areas():
	print("ASDFADS AS damagearea damaging overlapping...", get_overlapping_areas())
	for area in get_overlapping_areas():
		if area is Hurtbox:
			print("area is hurtbox, damaging")
			area._damage(self)
