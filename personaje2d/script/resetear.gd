extends Area2D

@export var player_teleport_position: Vector2

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body is CharacterBody2D:
		call_deferred("reset_game")

func reset_game():
	get_tree().reload_current_scene()
