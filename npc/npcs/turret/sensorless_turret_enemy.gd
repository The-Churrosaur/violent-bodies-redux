extends NPCBody


@export var sensors: Array[Sensor]

@onready var fire_control_manager: FireControlManager = $Weapon/FireControlManager


func _ready() -> void:
	fire_control_manager.sensors = sensors
