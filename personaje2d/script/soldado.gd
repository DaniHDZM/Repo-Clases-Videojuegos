extends Area2D

var health = 20

func _ready():
	add_to_group("enemies")

func take_damage(amount):
	health -= amount
	print("Enemigo recibió daño. Vida restante: ", health)
	if health <= 0:
		die()

func die():
	queue_free()
