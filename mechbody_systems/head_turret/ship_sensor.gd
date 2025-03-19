
## detects ships by accumulating a 'detection score' of 
## ( sensor strength * target rcs / distance^2 ) over time if target is in area.
## once dectection score exceeds background noise, reports that target has been acquired.
## if detection score drops below noise, reports target as lost.
## while resolving the target, sensor power increases by a 'tuning coefficient' 
## from zero to max power over time


class_name ShipSensor
extends Node3D


## sensor is attampting to detect a new target
signal new_target(body : PhysicsBody3D, sensor : ShipSensor)

## target left sensor before being detected
signal failed_to_acquire_target(body : PhysicsBody3D, sensor : ShipSensor)

## sensor has detected this target 
signal target_acquired(body : PhysicsBody3D, sensor : ShipSensor)

## sensor has lost this target 
signal target_lost(body : PhysicsBody3D, sensor : ShipSensor)


@export var sensor_display : Label3D
@export var tuning_display : Label3D


@export_subgroup("Sensor Options")


## sensor will attempt to track and acquire multiple targets
@export var multi_target = true

## while enabled, sensor will detect and attempt to acquire new targets
@export var seeking = true


@export_subgroup("Sensor Parameters")


## detector strength 
@export var sensor_strength = 5000.0

## percent/second increase of sensor strength per target
@export var tuning_coefficient = 0.5

## default noise level to be overcome
@export var default_noise = 1.0

## sensor base (to calculate distance)
@export var sensor_base : Node3D


## sensor detection area
@onready var sensor_area = $SensorArea

## current noise - can be manipulated by environment
@onready var noise = default_noise


## bodies currently being scanned -> current tuning value
var detected = {}

## bodies that have been successfully acquired -> tuning value
var acquired = {}



# CALLBACKS ==================================================================== 



func _on_sensor_area_body_entered(body):
	
	if body is TrainingBot: print("TRAINING BOT: ", body)
	else: return
	
	if !body.is_in_group("SensorDetect"): 
		print("body is not in sensordetect group")
		return
	if acquired.has(body): 
		print("body is already acquired")
		return
	
	# if new contact, add to purgatory for further investigation
	_new_target(body)


func _on_sensor_area_body_exited(body):
	
	if !body.is_in_group("SensorDetect"): return
	if detected.has(body): _failed_to_acquire(body)


func _physics_process(delta):
	
	if tuning_display: tuning_display.text = str(detected)
	
	# process detected targets
	for body in detected.keys():
		
		# target has been destroyed
		if !is_instance_valid(body): 
			print("sensor failed to acquire target as target has been destroyed")
			_failed_to_acquire(body)
			continue
		
		# set tuning value
		var tuning = detected[body]
		detected[body] = min( 1.0, tuning + tuning_coefficient * delta )
		
		# check detection value / acquisition
		if _calculate_detection_value(body) > noise: _target_acquired(body)
	
	# process acquired targets
	for body in acquired.keys():
		if !is_instance_valid(body): _target_lost(body)
		elif _calculate_detection_value(body, acquired[body]) > noise: _target_lost(body)



# PUBLIC =======================================================================



func get_acquired_target(id = 0):
	return acquired[id]



# PRIVATE ======================================================================



func _calculate_detection_value(body : PhysicsBody3D, tuning = detected[body]) -> float:
	
	if !detected.has(body): return 0.0
	
	var rcs = 1.0 # TODO
	var distance = sensor_base.global_position.distance_squared_to(body.global_position)
	
	return (tuning * sensor_strength * rcs) / distance



# -- TARGET STATE TRANSITIONS


func _new_target(body):
	detected[body] = 0
	new_target.emit(body, self)
	
	print("sensor detected new target: ", body)
	sensor_display.text = "sensor detected new target: " + str(body)


func _failed_to_acquire(body):
	detected.erase(body)
	failed_to_acquire_target.emit(body, self)
	
	print("sensor failed to acquire target: ", body)
	sensor_display.text = "sensor failed to acquire target: " + str(body)


func _target_acquired(body):
	
	# if multi-target locking is disabled and an acquired target exists
	if !multi_target and acquired.size() > 0: return
	
	if !detected.has(body): return
	
	# move from detedted to acquired
	acquired[body] = detected[body]
	detected.erase(body)
	target_acquired.emit(body, self)
	
	print("sensor acquired new target: ", body)
	sensor_display.text = "sensor acquired new target: " + str(body)


func _target_lost(body):
	if acquired.has(body): acquired.erase(body)
	target_lost.emit(body, self)
	
	print("sensor lost new target: ", body)
	sensor_display.text = "sensor lost new target: " + str(body)
	
	_new_target(body)
