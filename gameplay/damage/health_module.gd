
# tracks health
class_name HealthModule
extends Node


signal health_zero()
signal health_changed(amount)
@export var health = 5


func change_health(amount : int):
	#print("health module health changed, ", amount)
	if health <= 0 : return
	health += amount
	if health <= 0 : health_zero.emit()
	
	health_changed.emit(amount)
