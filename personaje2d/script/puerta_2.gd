extends Node2D

@export var puerta_2: AnimatedSprite2D  # Referencia al sprite animado
@export var duracion: float = 10.0   # Tiempo que la puerta permanecerá abierta

func aplicar_power_up():
	if puerta_2:
		puerta_2.play("open")  # Cambia a la animación de abrirse
		print("Puerta activada!")

		var timer = Timer.new()
		timer.wait_time = duracion
		timer.one_shot = true
		timer.timeout.connect(func():
			puerta_2.play("default")  # Regresa a la animación de cerrarse
			print("Puerta desactivada")
			timer.queue_free()
		)
		add_child(timer)
		timer.start()
