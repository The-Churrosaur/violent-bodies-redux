
## if told to engage, and ready, will fire bursts
extends WeaponAttacker


@export_subgroup("Components")

@export var gunbase : GunBase

@export_subgroup("Parameters")

@export var burst_time = 0.5
@export var cool_time = 1.0

var weapon_is_engaging
var weapon_is_ready
var weapon_is_aimed


func _physics_process(delta: float) -> void:
	pass


## get ready to fire/fx
func ready_weapon():
	weapon_is_ready = true


## weapon is aimed
func weapon_aimed():
	weapon_is_aimed = true


## weapon is no longer aimed
func weapon_lost_aim():
	weapon_is_aimed = false


## clear to fire 
func engage():
	weapon_is_engaging = true
	if weapon_is_ready: _fire_bursts()


## ready but not engaging
func hold_fire():
	weapon_is_engaging = false


## cease fire
func cease_fire():
	weapon_is_engaging = false
	weapon_is_ready = false


func _fire_bursts():
	await get_tree().create_timer(cool_time).timeout
	gunbase.pull_trigger()
	await get_tree().create_timer(burst_time).timeout
	gunbase.release_trigger()
	
	# again
	if weapon_is_engaging and weapon_is_ready: _fire_bursts() 
