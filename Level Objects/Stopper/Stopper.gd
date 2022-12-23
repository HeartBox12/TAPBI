extends Area2D

var active = false

func _physics_process(_delta):
	if (active && Input.is_action_just_pressed("ui_accept")): #FIXME: create custom input
		stop()
	#active = false


func _on_Stopper_body_entered(body):
	if (body == Global.player):
		active = true


func _on_Stopper_body_exited(body):
	if (body == Global.player):
		active = false
		
func stop():
	Global.player.linear_velocity = Vector2(0, 0)
	active = false
