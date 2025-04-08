
class_name TurretNPCController
extends NPCController


@export var enabled = false

@export_subgroup("components")
@export var weapon_system_turret: WeaponSystem 
@export var fire_control_manager: FireControlManager
@export var health : HealthModule
@export var death : NPCDeath


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	health.health_zero.connect(_on_health_module_health_zero)
	
	while true:
	
		await get_tree().create_timer(5).timeout
		
		if enabled:
		
			fire_control_manager.set_engagement_at_will()


func _on_health_module_health_zero():
	print("turret controller health zero")
	_start_dying()


func _start_dying():
	death.die()
	weapon_system_turret.cease_fire()
	
	await death.done_dying
	
	body.die()
