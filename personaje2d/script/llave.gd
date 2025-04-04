extends Area2D

@export var puerta: Node2D  # Referencia a la puerta

func _on_body_entered(body):
	if body is CharacterBody2D:
		if puerta:
			puerta.aplicar_power_up()  # Eliminar la llave después de ser recogida
		else:
			print("Error: La puerta no está asignada en el Inspector.")
