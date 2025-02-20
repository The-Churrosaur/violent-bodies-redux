extends Node3D

@export var bot_template : PackedScene
@export var bot_target : Node3D
@export var enabled = false
@export var max_bots = 3

var bots = 0

func _ready():
	enabled = false



func _on_timer_timeout():
	if !enabled : return
	
	if bots >= max_bots: return
	
	var bot = bot_template.instantiate()
	bot.spawner = self
	bot.player = bot_target
	add_child(bot)
	print("spawning... ", bot)
	bots += 1
