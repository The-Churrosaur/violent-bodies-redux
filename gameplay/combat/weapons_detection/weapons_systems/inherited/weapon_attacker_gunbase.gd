
## if told to engage and aimed and ready, will hold down trigger
extends WeaponAttacker


@export_subgroup("Components")

@export var gunbase : GunBase

var weapon_is_engaging
var weapon_is_ready
var weapon_is_aimed


func _physics_process(delta: float) -> void:
	#print(weapon_is_ready, weapon_is_aimed, weapon_is_engaging)
	#if weapon_is_ready and weapon_is_aimed and weapon_is_engaging:
		#gunbase.hold_trigger()
	if weapon_is_ready and weapon_is_engaging: 
		gunbase.hold_trigger()


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


## ready but not engaging
func hold_fire():
	weapon_is_engaging = false


## cease fire
func cease_fire():
	weapon_is_engaging = false
	weapon_is_ready = false
