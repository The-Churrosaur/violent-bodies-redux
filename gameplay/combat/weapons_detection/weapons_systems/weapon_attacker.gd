
## inheritable intermediary between weapons sytem and the actual gun/strike etc.


class_name WeaponAttacker
extends Node3D

var target

func attack(target):
	print("wa attacking")
	self.target = target
	pass


func stop_attack():
	print("wa stopping")
	target = null
	pass
