extends Area2D

@export var SPEED: int = 500
@export var DAMAGE: int = 10

func _ready():
	$AnimatedSprite2D.play("disparo")

func _process(delta):
	global_position.x += SPEED * delta
	
func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(DAMAGE)
		queue_free()
	

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free() # Replace with function body.
