class_name TargetLeadManager
extends Node3D

@export var current_weapon : BasicMechGun
@export var shoot_ui : Node3D

@onready var lead_computer : LeadComputer = %LeadComputer
@onready var target_lead_ui : TargetLeadUI = %TargetLeadUI

## injected by head sensor manager
var current_target : PhysicsBody3D = null



func _ready():
	set_new_weapon(current_weapon)


func _physics_process(delta):
	
	if current_target == null: 
		target_lead_ui.visible = false
		return
	
	var collision_point = lead_computer.predict(current_target)
	if collision_point == null:
		target_lead_ui.visible = false
	else: 
		target_lead_ui.visible = true
		target_lead_ui.global_position = collision_point
	#print(global_position, lead_computer.collision_time)
	
	shoot_ui.visible = lead_computer.check_aim(collision_point)
	


## called by head sensor manager
func set_new_target(target):
	current_target = target

func target_lost():
	current_target = null
	pass

func set_new_weapon(weapon : BasicMechGun):
	current_weapon = weapon
	lead_computer.muzzle_reference = weapon.muzzle
	lead_computer.projectile_velocity = weapon.get_muzzle_velocity()

