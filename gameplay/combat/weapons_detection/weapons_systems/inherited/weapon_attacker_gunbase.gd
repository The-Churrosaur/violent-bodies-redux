
## if told to engage will hold down trigger
extends WeaponAttacker


@export_subgroup("Components")

@export var gunbase : GunBase


func attack():
	super()
	gunbase.pull_trigger()


func stop_attack():
	super()
	gunbase.release_trigger()
