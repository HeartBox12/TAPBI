extends Node2D

var leftPressed = false
var rightPressed = false
var pausing = false
export(int) var vibradius#Degree to which the screen vibrates
export(PackedScene) var next

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = $Player
	$Player.hasBoost = false #Prevent from boosting during the cinematic

func _input(event):
	if (event.is_action_pressed("ui_left") && !leftPressed):
		$Cinematographer/Camera2D/LeftPrompt.frame = 1 #and play a sound
		leftPressed = true
		
	elif (event.is_action_pressed("ui_right") && !rightPressed):
		$Cinematographer/Camera2D/RightPrompt.frame = 1 #and play a sound
		rightPressed = true

	if (leftPressed && rightPressed):
		$Cinematographer.linear_damp = 1
		
		$Tween.interpolate_property(self, "vibradius", vibradius, 0, 2)
		$Tween.start()

func _process(_delta):
	if ($Player.global_position.y < $Cinematographer.global_position.y && !pausing):
		pausing = true
		$Pause.start()
	
	$Cinematographer/Camera2D.position = Vector2.RIGHT.rotated(randf() * 2 * PI) * vibradius

func _on_pause():
	get_tree().change_scene_to(next)


func _UILoop():
	if $Cinematographer/Camera2D/UIMine.visible:
		$Cinematographer/Camera2D/UIMine.visible = false
	else:
		$Cinematographer/Camera2D/UIMine.visible = true
