
class_name BasicMechGun
extends MechTool

signal emit_recoil(gun : BasicMechGun, recoil : Vector3)

@export var recoil = 20
@export var play_audio = true
@export var play_muzzle_flash = true

@export var gun : StupidGun
@export var trigger_action : String = "trigger_click"
@export var launching_rigidbody : RigidBody3D
@export var muzzle : Node3D

@export var laser : MeshInstance3D
@export var blinker : Blinker
@export var muzzle_flash : Node3D

@export var mechbody : MechBody
@export var hand : MechHand

@onready var audio_stream_player_3d = $AudioStreamPlayer3D


func _ready():
	super()
	gun.launching_rigidbody = launching_rigidbody


#func _physics_process(delta):
	#print(muzzle.global_transform.basis.z)


func on_controller_input_pressed(action):
	super(action)
	if action == trigger_action: 
		gun.pull_trigger()
		muzzle_flash.play_fx()

func on_controller_input_released(action):
	super(action)
	if action == trigger_action: 
		gun.release_trigger()
		muzzle_flash.stop_fx()


func _on_stupidgun_firing():
	grabbable_controller.controller.trigger_haptic_pulse("haptic", 5, 0.4, 0.2, 0)
	emit_recoil.emit(self, global_basis.z * recoil)
	
	# recoil
	var pos = muzzle.global_position - launching_rigidbody.global_position
	launching_rigidbody.apply_impulse(global_basis.z * recoil, pos)
	
	#var spawn = audio_spawn.instantiate()
	#add_child(spawn)
	#spawn.global_position = global_position
	#spawn.play(0.4)
	
	if play_audio: audio_stream_player_3d.play(0.8)
	#if play_muzzle_flash: muzzle_flash.play_fx()
	
	#laser.visible = true
	#await get_tree().create_timer(0.05).timeout
	#laser.visible = false


func activate(hand, controller : MyXRGrabbable = null):
	
	print("GUN ACTIVATING: ", hand, controller)
	
	super(hand, controller)
	
	self.hand = hand
	mechbody = hand.mechbody
	launching_rigidbody = hand.get_hand_bit().hand
	gun.launching_rigidbody = launching_rigidbody
	
	print("GUN LAUNCHBODY: ", launching_rigidbody)
	
	#laser.visible = true
	pass

func deactivate():
	super()
	
	self.mechbody = null
	launching_rigidbody = null
	
	laser.visible = false
	pass


func get_muzzle_velocity():
	# TODO TODO
	return 500
