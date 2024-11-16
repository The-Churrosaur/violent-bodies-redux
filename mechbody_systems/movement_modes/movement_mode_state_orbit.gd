extends MovementModeState

@export var sensor_manager : HeadSensorManager
@export var rotator : MechRotator
@export var headlook_controller : HeadlookController


func _ready():
	sensor_manager.target_changed.connect(_on_target_changed)


func enter_state():
	super()
	
	rotator.track_target(sensor_manager.current_target)
	
	headlook_controller.pitch_disabled = true
	headlook_controller.yaw_disabled = true
	headlook_controller.roll_disabled = false

func exit_state():
	super()
	rotator.stop_tracking()


# can enter orbit if sensor manager has a valid target
func can_enter() -> bool :
	if sensor_manager.current_target != null: return true
	else: return false


func _on_target_changed(target, old_target):
	
	# testing
	if target == null: 
		print("orbit state received target change: deactivating")
		controller.enter_state()
	#else: 
		#print("orbit state received target change: activating")
		#controller.enter_state("orbit")
