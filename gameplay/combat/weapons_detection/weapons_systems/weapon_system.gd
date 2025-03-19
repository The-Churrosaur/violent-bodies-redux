
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


func _on_aimer_target_acquired():
	weapon_attacker.weapon_aimed()


func _on_aimer_target_lost():
	weapon_attacker.weapon_lost_aim()


## -- called by ai manager / state machine


## tell aimer to aim at target, ready weapon
func ready_aim():
	if !target: no_target.emit(); return
	weapon_aimer.acquire_target(target)
	weapon_attacker.ready_weapon()
	state = WS_STATE.TRACKING


## track if not tracking, engage
func engage():
	if !target: no_target.emit(); return
	if state == WS_STATE.IDLE: ready_aim()
	weapon_attacker.engage()
	state = WS_STATE.ENGAGING


## return to tracking
func hold_fire():
	if state != WS_STATE.ENGAGING: return
	weapon_attacker.cease_fire()
	state = WS_STATE.TRACKING


## return to idle
func cease_fire():
	if state != WS_STATE.ENGAGING: return
	weapon_aimer.cease_fire()
	weapon_attacker.cease_fire()
	state = WS_STATE.IDLE


## -- called by fire control manager 


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
