

extends Level
@onready var bot_spawner = $Base/BotSpawner
@onready var bot_spawner_2 = $Base/BotSpawner2


func _ready() -> void:
	super()
	#toggle_spawners()


func toggle_spawners():
	bot_spawner.enabled = !bot_spawner.enabled
	#bot_spawner_2.enabled = !bot_spawner_2.enabled
