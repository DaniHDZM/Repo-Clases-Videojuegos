extends Area2D

@export var duration: float = 5.0  # Tiempo que dura el efecto en segundos
@export var animation_name: String = "default"  # Nombre de la animación

func _ready():
	$AnimatedSprite2D.play(animation_name)  # Reproduce la animación del power-up

func _on_body_entered(body):
	if body is CharacterBody2D:  # Verifica si el personaje toca el power-up
		body.activate_damage_boost(duration)  # Activa el doble de daño en el personaje
		queue_free()  # Elimina el power-up tras ser recogido
