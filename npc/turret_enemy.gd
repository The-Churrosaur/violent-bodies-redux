extends RigidBody3D

@export var enabled = true

@onready var weapon_system_turret: WeaponSystem = $Weapon/WeaponSystemTurret
@onready var fire_control_manager: FireControlManager = $Weapon/FireControlManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await get_tree().create_timer(1).timeout
	
	if enabled:
	
		fire_control_manager.distribute_targets()
		weapon_system_turret.ready_aim()
		weapon_system_turret.engage()
