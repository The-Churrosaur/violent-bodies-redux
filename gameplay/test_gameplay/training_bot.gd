
class_name TrainingBot
extends NPCBody


@export var impulse = 500.0
@export var player : Node3D
@export var slerp_speed = 2 # per second

@export var gun : GunBase


@onready var jitter_timer = $Timer
@onready var shoot_timer = $Timer2
@onready var health = $HealthModule
@onready var mechmesh = $mechmesh
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var lead_computer = $LeadComputer


var r = RandomNumberGenerator.new()

var spawner
var destroyed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	r.seed = name.hash()
	
	#await get_tree().create_timer(5).timeout
	#die()
	
	$GunBase.pull_trigger()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	player = LevelGlobals.level.player_body
	
	if player == null : return
	
	$looker.look_at(player.global_position)
	var target_pos = lead_computer.predict(player)
	if target_pos != null: $looker.look_at(target_pos)
	else: $looker.look_at(player.global_position)
	
	var a = Quaternion(transform.basis)
	var b = Quaternion($looker.global_transform.basis)
	var c = a.slerp(b, slerp_speed * delta)
	transform.basis = Basis(c)
	
	#global_transform = global_transform.interpolate_with($looker.global_transform, slerp_speed * delta)
	
	#print("drone ", linear_velocity)
	
	#if global_position.distance_squared_to(player.global_position) < 1000:
		#apply_central_impulse(transform.basis.z * impulse * delta * 50)
	#else:
		#apply_central_impulse(-transform.basis.z * impulse * delta)
	apply_central_impulse(-transform.basis.z * impulse * delta)
	





func _on_shooter_timer_timeout():
	gun.trigger()


func explode():
	if destroyed: return
	destroyed = true
	
	spawner.bots -= 1
	
	freeze = true
	mechmesh.visible = false
	gun.safety = true
	audio_stream_player_3d.stop()
	$explosionFX.start_explosion_sequence()
	player.destroyed_enemy(self)
	
	#var vec = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	#$SliceableComponent.slice(vec, global_position)
	
	if (player.global_position - global_position).length_squared() < 400:
		Engine.time_scale = 0.2
		await get_tree().create_timer(0.1).timeout
		Engine.time_scale = 1.0


func _on_explosion_fx_explosion_ended():
	mechmesh.visible = false
	die()


func _on_health_module_health_zero():
	explode()


func _on_health_module_health_changed(amount: Variant) -> void:
	$DamageFx.play()
