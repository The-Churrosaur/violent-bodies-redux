extends Node3D

@onready var smoke_puff = $SmokePuff
@onready var shockwave = $Shockwave
@onready var timer = $Timer


func play_fx():
	smoke_puff.emitting = true
	shockwave.emitting = true
	timer.start()

func _on_timer_timeout():
	pass
	#queue_free()
