extends CharacterBody2D

const SPEED = 300.0  # Velocidad horizontal del personaje
const JUMP_VELOCITY = -550.0  # Velocidad del salto (negativa porque va hacia arriba)
const STAND_TO_IDLE_DELAY = 0.5  # Tiempo antes de pasar de "stand" a "idle"
const DUCK_DURATION = 0.2  # Duración de la animación "duck" al aterrizar después de un salto o caída

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # Referencia al sprite animado del personaje
@onready var HieloBalaScene = preload("res://disparo_hielo.tscn")
# Variables de estado
var stand_timer = 0.0  # Temporizador para cambiar de "stand" a "idle"
var duck_timer = 0.0  # Temporizador para controlar la duración de la animación "duck"
var was_in_air = false  # Indica si el personaje estaba en el aire
var is_ducking = false  # Indica si el personaje está agachado
var landed_from_jump = false  # Indica si acaba de aterrizar

# Función principal del ciclo de físicas que se ejecuta cada frame
func _physics_process(delta):
	handle_gravity(delta)  # Aplicar la gravedad si no está en el suelo
	handle_movement(delta)  # Controlar el movimiento horizontal
	handle_jump()  # Verificar si el personaje salta
	handle_manual_duck()  # Manejar el agachado manual con la tecla abajo
	handle_landing(delta)  # Verificar y manejar el aterrizaje después de un salto o caída
	move_and_slide()  # Mover el personaje y aplicar la física de colisiones
	handle_shooting() 

# Aplica la gravedad cuando el personaje está en el aire
func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

# Controla el movimiento horizontal del personaje
func handle_movement(delta):
	var direction = Input.get_axis("ui_left", "ui_right")  # Obtener la dirección de entrada (izquierda/derecha)
	if direction != 0 and not is_ducking and not landed_from_jump:
		velocity.x = direction * SPEED  # Aplicar velocidad en la dirección ingresada
		sprite.flip_h = direction < 0  # Voltear el sprite si se mueve a la izquierda
		if is_on_floor():
			sprite.play("walk")  # Reproducir animación de caminar
		reset_timers()  # Reiniciar temporizadores
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)  # Detener movimiento gradualmente
		if is_on_floor() and not is_ducking and not landed_from_jump:
			handle_idle_transition(delta)  # Controlar transición a "idle"

# Verifica si el personaje debe saltar
func handle_jump():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Aplicar velocidad de salto
		sprite.play("jump")  # Reproducir animación de salto
		was_in_air = true  # Marcar que está en el aire

# Maneja el agachado manual con la tecla hacia abajo
func handle_manual_duck():
	if Input.is_action_pressed("ui_down") and is_on_floor():
		is_ducking = true
		sprite.play("duck")  # Reproducir animación de agacharse
	else:
		is_ducking = false

# Controla el aterrizaje después de un salto o caída
func handle_landing(delta):
	if was_in_air and is_on_floor():
		landed_from_jump = true  # Marcar que aterrizó
		was_in_air = false  # Reiniciar estado de aire
		duck_timer = DUCK_DURATION  # Iniciar temporizador de "duck"
		sprite.play("jump")  # Reproducir animación de aterrizaje
	if landed_from_jump:
		duck_timer -= delta  # Reducir temporizador
		if duck_timer <= 0:
			landed_from_jump = false  # Finalizar estado de aterrizaje

# Controla la transición de "stand" a "idle" si el personaje está quieto
func handle_idle_transition(delta):
	if velocity.x == 0:
		stand_timer += delta  # Incrementar temporizador
		if stand_timer >= STAND_TO_IDLE_DELAY:
			sprite.play("idle")  # Cambiar a animación "idle"
	else:
		stand_timer = 0  # Reiniciar temporizador si se mueve

# Reinicia todos los temporizadores y estados
func reset_timers():
	stand_timer = 0
	duck_timer = 0
	landed_from_jump = false

func handle_shooting():
	if Input.is_action_just_pressed("ui_accept"):
		dispara_bala()

func dispara_bala():
	var bala = HieloBalaScene.instantiate()
	get_parent().add_child(bala)
	bala.global_position = global_position 
	var bala_sprite = bala.get_node("AnimatedSprite2D")
	if sprite.flip_h:
		bala.SPEED = -abs(bala.SPEED)
		bala_sprite.flip_h = true
	else:
		bala.SPEED = abs(bala.SPEED)
		bala_sprite.flip_h = false
