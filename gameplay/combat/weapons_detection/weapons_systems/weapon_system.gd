
class_name WeaponSystem
extends Node3D



## current state of the ws
enum WS_STATE {IDLE, TRACKING, ENGAGING}

signal new_target_assigned(target)
signal no_target()

@export var weapon_aimer : WeaponAimer
@export var weapon_attacker : WeaponAttacker
@export var target_prioritizer : WSTargetPrioritizer

var target : TargetTrack
var state : WS_STATE



func _ready() -> void:
	weapon_aimer.target_acquired.connect(_on_aimer_target_acquired)
	weapon_aimer.target_lost.connect(_on_aimer_target_lost)
	state = WS_STATE.IDLE


func _physics_process(delta: float) -> void:
	
	match state:
		WS_STATE.IDLE:
			pass
		WS_STATE.TRACKING:
			pass
		WS_STATE.ENGAGING:
			if weapon_aimer.target_is_acquired: 
			pass


func _on_aimer_target_acquired():
	weapon_attacker.weapon_aimed()


func _on_aimer_target_lost():
	weapon_attacker.weapon_lost_aim()


## -- called by fcm


func track_target(new_target : TargetTrack):
	target = new_target
	weapon_aimer.acquire_target(target)


func engage_target(new_target : TargetTrack):
	target = new_target
	weapon_aimer.acquire_target(target)
	weapon_attacker.engage()


### tell aimer to aim at target, ready weapon
#func set_tracking():
	#if !target: no_target.emit(); return
	#
	#if state == WS_STATE.IDLE:
		#weapon_aimer.acquire_target(target)
		#weapon_attacker.ready_weapon()
	#
	#if state == WS_STATE.ENGAGING:
		#weapon_attacker.cease_fire()
	#
	#state = WS_STATE.TRACKING
#
#
### track if not tracking, engage
#func set_engaging():
	#if !target: no_target.emit(); return
	#
	#if state == WS_STATE.IDLE: 
		#set_tracking()
	#
	#weapon_attacker.engage()
	#state = WS_STATE.ENGAGING
#
#
### return to idle
#func set_idle():
	#if state == WS_STATE.ENGAGING: 
		#weapon_aimer.cease_fire()
		#weapon_attacker.cease_fire()
	#
	#state = WS_STATE.IDLE


## ask prioritizer to choose a target from a list of targets
func choose_target(tracks : Array[TargetTrack]):
	return target_prioritizer.choose_target_track(tracks)


## STUB - can see target?
func has_los_to_target(track : TargetTrack):
	return true


## assigns a singular target for this WS to engage 
func assign_target(target):
	if !target: return 
	self.target = target
	new_target_assigned.emit(target)


## assigns a list of targets - chooses and assigns target
func assign_target_list(tracks : Array[TargetTrack]):
	assign_target(choose_target(tracks))
