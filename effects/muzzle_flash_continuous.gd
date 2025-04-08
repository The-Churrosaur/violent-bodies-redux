extends MyFX

@onready var smoke_puff = $SmokePuff
@onready var shockwave = $Shockwave

func play_fx():
	smoke_puff.emitting = true
	shockwave.emitting = true


func stop_fx():
	smoke_puff.emitting =false
	shockwave.emitting = false
