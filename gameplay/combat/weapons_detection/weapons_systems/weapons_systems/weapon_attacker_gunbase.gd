
## if told to engage will hold down trigger
extends WeaponAttacker


@export_subgroup("Components")

@export var gunbase : GunBase


func attack(target):
	super(target)
	gunbase.set_target(target)
	gunbase.pull_trigger()


func stop_attack():
	super()
	gunbase.reset_target()
	gunbase.release_trigger()
