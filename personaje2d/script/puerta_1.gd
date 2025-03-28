extends AnimatedSprite2D

@onready var sprite: AnimatedSprite2D = $"."  # Referencia al sprite animado del personaje


func _on_texture_button_pressed():
	sprite.play("open")
	pass
