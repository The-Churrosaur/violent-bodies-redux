
## inheritable intermediary between target assignment and shooter.
## points x at the target, then signals to WS
## encapsulate lead computing here.
## can also ie. tell missile or nose gun to engage.
## this takes authority for leeway in accuracy etc

class_name WeaponAimer
extends Node3D


signal target_acquired()
signal target_lost()

@export var aim_point : Marker3D

var target : TargetTrack
var target_is_acquired = false


func aim_target(target):
	self.target = target

func stop_aiming():
	target = null
