
class_name TrainingBot
extends RigidBody3D


@export var impulse = 500.0
@export var player : Node3D
@export var slerp_speed = 2 # per second

@export var gun : StupidGun

@onready var jitter_timer = $Timer
@onready var shoot_timer = $Timer2
@onready var health = $HealthModule
@onready var mechmesh = $mechmesh


var r = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	r.seed = name.hash()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	apply_central_impulse(-transform.basis.z * impulse * delta)
	
	
	if player == null : return
	
	$looker.look_at(player.global_position)
	
	var a = Quaternion(transform.basis)
	var b = Quaternion($looker.global_transform.basis)
	var c = a.slerp(b, slerp_speed * delta)
	transform.basis = Basis(c)
	
	#print("drone ", linear_velocity)
	


func _on_timer_timeout():
	#apply_impulse(Vector3(r.randf(), r.randf(), r.randf()) * impulse)
	#jitter_timer.start(1 + r.randf())
	pass
	


func _on_shooter_timer_timeout():
	gun.trigger()
	apply_impulse(-transform.basis.z * impulse * 2)
	shoot_timer.start(1 + r.randf())


func _on_area_3d_area_entered(area):
	print("trainingbot detected area")
	$Label3D.text = str(area)
	if area.is_in_group("laser"): 
		$Label3D.text = "hit by laser"
		if area.get("damage") : 
			_damage(area.damage)
		else:
			_damage()
		
func _damage(amount = 10):
	health.change_health(-amount)
	$DamageFx.play()

func explode():
	freeze = true
	mechmesh.visible = false
	gun.safety = true
	$explosionFX.start_explosion_sequence()
	player.destroyed_enemy(self)


func _on_explosion_fx_explosion_ended():
	mechmesh.visible = false
	queue_free()


func _on_health_module_health_zero():
	explode()
