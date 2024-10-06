extends Label3D
@onready var vhud_button_tap = $"../VHUDButtonTap"

func _on_vhud_button_tap_button_clicked():
	
	var spawner = LevelGlobals.level.bot_spawner
	spawner.enabled = !spawner.enabled
	if spawner.enabled:
		vhud_button_tap.label.text = "ENEMIES ENABLED"
	else:
		vhud_button_tap.label.text = "ENEMIES DISABLED"
