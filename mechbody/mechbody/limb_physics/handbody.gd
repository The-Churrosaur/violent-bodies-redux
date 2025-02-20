extends RigidBody3D

@onready var audio_stream_player_3d = $AudioStreamPlayer3D

var bonk_enabled = true


func _on_body_entered(body):
	#print("BONK")
	if !bonk_enabled: return
	
	audio_stream_player_3d.pitch_scale = 1  - linear_velocity.length_squared() / 1000
	audio_stream_player_3d.play()
	bonk_enabled = false
	await get_tree().create_timer(1.0).timeout
	bonk_enabled = true
	
