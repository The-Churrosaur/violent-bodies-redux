
class_name BasicMechGun
extends MechTool

signal emit_recoil(gun : BasicMechGun, recoil : Vector3)

@export var gun : StupidGun
@export var trigger_action : String = "trigger_click"
@export var launching_rigidbody : RigidBody3D
@export var muzzle : Node3D

@export var laser : MeshInstance3D
@export var blinker : Blinker

@export var recoil = 20
@export var mechbody : MechBody
@export var hand : MechHand

@onready var audio_stream_player_3d = $AudioStreamPlayer3D


func _ready():
	super()
	gun.launching_rigidbody = launching_rigidbody


#func _physics_process(delta):
	#print(muzzle.global_transform.basis.z)


func on_controller_input_pressed(action):
	print("gun receiving controller: ", action)
	super(action)
	if action == trigger_action: 
		gun.pull_trigger()
		#audio_stream_player_3d.play()

func on_controller_input_released(action):
	super(action)
	if action == trigger_action: 
		gun.release_trigger()
		#audio_stream_player_3d.stop()


func _on_stupidgun_firing():
	grabbable_controller.controller.trigger_haptic_pulse("haptic", 5, 0.4, 0.2, 0)
	emit_recoil.emit(self, global_basis.z * recoil)
	
	# recoil
	var pos = muzzle.global_position - launching_rigidbody.global_position
	launching_rigidbody.apply_impulse(global_basis.z * recoil, pos)
	print("gun attempting to recoil: ", launching_rigidbody)
	
	#var spawn = audio_spawn.instantiate()
	#add_child(spawn)
	#spawn.global_position = global_position
	#spawn.play(0.4)
	
	audio_stream_player_3d.play(0.8)


func activate(hand, controller : MyXRGrabbable = null):
	
	print("GUN ACTIVATING: ", hand, controller)
	
	super(hand, controller)
	
	self.hand = hand
	mechbody = hand.mechbody
	launching_rigidbody = hand.get_hand_bit().hand
	gun.launching_rigidbody = launching_rigidbody
	
	print("GUN LAUNCHBODY: ", launching_rigidbody)
	
	#laser.visible = true
	blinker.active = true
	pass

func deactivate():
	super()
	
	self.mechbody = null
	launching_rigidbody = null
	
	laser.visible = false
	blinker.active = false
	pass


func get_muzzle_velocity():
	# TODO TODO
	return 400
