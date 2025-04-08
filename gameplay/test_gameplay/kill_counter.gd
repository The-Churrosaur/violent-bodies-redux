
## tracks local exploding enemies

class_name KillCounter
extends Node3D


signal enemy_killed(body)

var tracked_enemies = {}


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is NPCBody:
		if tracked_enemies.keys().has(body): return
		else: _track_enemy(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is NPCBody:
		_lose_enemy(body)


func _track_enemy(body : NPCBody):
	tracked_enemies[body] = true
	body.death.connect(_on_tracked_enemy_killed.bind(body))


func _lose_enemy(body):
	tracked_enemies[body] = false


func _on_tracked_enemy_killed(body):
	enemy_killed.emit(body)
	_lose_enemy(body)
