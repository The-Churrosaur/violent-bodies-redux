

## base class for guns.
## attempts to mechanistically simulate the firing cycle of a weapon with state.
## does not implement actually shooting/lasing w/e. Takes a shooter node.
## implement burst as special firing if needed.
## also handles recoil


class_name GunBase
extends Node3D


signal firing()


enum GUN_STATE {CYCLING, BATTERY, OUT_BATTERY}


@export_subgroup("Components")

@export var shooter : Shooter
@export var launching_rigidbody : RigidBody3D

@export_subgroup("Parameters")

@export var launch_force = 100000.0
@export var is_automatic = true
@export var cycle_when_empty = true ## if true, will cycle the gun to BATTERY on empty
@export var cycle_time = 0.05


@onready var safety = false
@onready var cycle_timer = $CycleTimer


var current_state : GUN_STATE = GUN_STATE.OUT_BATTERY
var trigger_down = false
var is_empty = false ## set me! checked before and after cycling 
var bullet_parent


# CALLBACKS  -------------------------------------------------------------------


func  _ready():
	await get_tree().process_frame
	bullet_parent = LevelGlobals.level


func _on_cycle_timer_timeout():
	current_state = GUN_STATE.BATTERY
	
	# does not fire if empty
	if is_empty: 
		_click()
		return
	
	# starts cycle again if automatic
	if is_automatic and trigger_down: _fire()



# PUBLIC -----------------------------------------------------------------------



## trigger weapon once
func trigger():
	pull_trigger()
	release_trigger()


## for process methods
func hold_trigger():
	if !trigger_down: pull_trigger() 


func pull_trigger():
	
	if safety : return
	
	trigger_down = true
	
	match current_state:
		GUN_STATE.BATTERY: _fire()
		GUN_STATE.OUT_BATTERY: _click()
		GUN_STATE.CYCLING: _clunk()


func release_trigger():
	trigger_down = false


## cycles the action (done automatically if gun is automatic)
## does not cycle if empty
func cycle():
	
	# does not cycle if empty and told not to
	if is_empty and !cycle_when_empty: 
		_click()
		return
	
	current_state = GUN_STATE.CYCLING
	cycle_timer.start(cycle_time)



# PRIVATE ----------------------------------------------------------------------



# internally fires the weapon. if automatic, starts cycling the gun
func _fire():
	
	shooter.fire(self)
	
	firing.emit()
	current_state = GUN_STATE.OUT_BATTERY
	if is_automatic: cycle()


# if trigger is pulled while gun is out of battery
func _click():
	pass

# if trigger is pulled while gun is cycling 
func _clunk():
	pass
