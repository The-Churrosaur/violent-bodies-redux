
## processes and routes information from physical sensors (sensorhead) to the headpointer (player ui)

class_name HeadSensorManager
extends Node3D

signal target_changed(target, old_target)

@export var sensor : ShipSensor
@export var helmet : HeadPointer
@export var lock_ui : TargetLockUI
@export var lead_manager : TargetLeadManager


var current_target : PhysicsBody3D = null


func _ready():
	
	# connect signals from sensor
	sensor.new_target.connect(_on_sensor_new_target)
	sensor.failed_to_acquire_target.connect(_on_sensor_failed_to_acquire_target)
	sensor.target_acquired.connect(_on_sensor_target_acquired)
	sensor.target_lost.connect(_on_sensor_target_lost)


func _on_sensor_new_target(body, sensor):
	pass

func _on_sensor_failed_to_acquire_target(body, sensor):
	pass


func _on_sensor_target_acquired(body, sensor):
	lock_ui.set_target(body)
	current_target = body
	
	lead_manager.set_new_target(body)
	
	print("sensor manager acquired target")
	target_changed.emit(body, current_target)


func _on_sensor_target_lost(body, sensor):
	lock_ui.lost_target()
	current_target = null
	
	lead_manager.target_lost()
	
	print("sensormanager lost target")
	target_changed.emit(null, body)
