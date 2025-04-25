class_name MechBooster
extends Node3D

@export var boost_input = 1.5
@export var boost_time = 0.5
@export var cooldown_time = 2.0
@export var mechbody : MechBody

var _boost_fore = 0
var _boost_strafe = 0
var _boost_vertical = 0

var cooldown = false


func _physics_process(delta):
	
	mechbody.front_input += _boost_fore
	mechbody.strafe_input += _boost_strafe
	mechbody.climb_input += _boost_vertical


func boost_fore(mult = 1.0, time = boost_time):
	if cooldown: return
	
	_boost_fore = boost_input * mult
	_start_cooldown()
	await get_tree().create_timer(time).timeout
	_boost_fore = 0


func boost_strafe(mult = 1.0, time = boost_time):
	if cooldown : return
	
	var strafe_vel = mechbody.local_velocity.x
	if sign(strafe_vel) != sign(mult): mult -= strafe_vel * 0.01
	
	# mult *= -strafe_vel * 0.05
	 
	_boost_strafe = boost_input * mult
	_start_cooldown()
	await get_tree().create_timer(time).timeout
	_boost_strafe = 0


func boost_vertical(mult = 1.0, time = boost_time):
	if cooldown: return
	
	_boost_vertical = boost_input * mult
	_start_cooldown()
	await get_tree().create_timer(time).timeout
	_boost_vertical = 0


func _start_cooldown(time = cooldown_time):
	cooldown = true
	await get_tree().create_timer(time).timeout
	cooldown = false
