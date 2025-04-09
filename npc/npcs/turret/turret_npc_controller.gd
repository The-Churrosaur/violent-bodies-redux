
class_name TurretNPCController
extends NPCController


@export var enabled = true

@export_subgroup("components")
@export var weapon_system_turret: WeaponSystem 
@export var fire_control_manager: FireControlManager
@export var health : HealthModule
@export var death : NPCDeath


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	health.health_zero.connect(_on_health_module_health_zero)
		
	await get_tree().create_timer(1).timeout
	
	if enabled:
		
	
		fire_control_manager.set_engagement_free()
		print("telling wa to attack")
		
		#$"../Weapon/WeaponSystemTurret/WeaponAttacker".attack()
		


func _on_health_module_health_zero():
	print("turret controller health zero")
	_start_dying()


func _start_dying():
	death.die()
	
	await death.done_dying
	
	fire_control_manager.set_engagement_hold()
	
	print("done awaiting death anim")
	
	body.die()
