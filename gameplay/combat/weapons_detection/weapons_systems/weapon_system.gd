
## responsible for aimer and attacker.
## by default will 

class_name WeaponSystem
extends Node3D



## current state of the ws
enum WS_STATE {IDLE, TRACKING, ENGAGING}

signal new_target_assigned(target)
signal no_target()

@export var attack_while_aiming = false

@export_category("components")

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
	if state == WS_STATE.TRACKING:
		weapon_attacker.attack()
		state == WS_STATE.ENGAGING


func _on_aimer_target_lost():
	print("ws aimer lost, state; ", state)
	#if state == WS_STATE.ENGAGING:
	print("ws stopping attack")
	weapon_attacker.stop_attack()
	state == WS_STATE.TRACKING


## -- called by fcm


func engage_target(new_target : TargetTrack):
	target = new_target
	weapon_aimer.aim_target(target)
	if attack_while_aiming:
		weapon_attacker.attack()
		state = WS_STATE.ENGAGING
	else:
		state = WS_STATE.TRACKING


func disengage():
	target = null
	weapon_aimer.stop_aiming()
	weapon_attacker.stop_attack()
	
	state = WS_STATE.IDLE
