extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	is_on_ceiling()
	position = Vector2()
	
	position = position.normalized()
	
func _input(event):
	"ui_accept"
	if event.is_action_pressed("ui_accept"):
		apply_central_impulse(Vector2(-100, 0))
