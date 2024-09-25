
class_name Level
extends Node3D
@onready var bot_spawner = $Base/BotSpawner


func _ready():
	LevelGlobals.level = self


func _on_restart_button_button_pressed(button):
	bot_spawner.enabled = !bot_spawner.enabled
