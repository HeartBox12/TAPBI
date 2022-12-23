extends Node2D

var leftPressed = false
var rightPressed = false
var pausing = false
export(int) var vibradius#Degree to which the screen vibrates
export(PackedScene) var next

var pressed1 = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = $Player
	$Player.hasBoost = false #Prevent from boosting during the cinematic

func _input(event):
	if (event.is_action_pressed("ui_left") && !leftPressed):
		$Cinematographer/Camera2D/LeftPrompt.frame = 1 #and play a sound
		leftPressed = true
		
		if rightPressed:
			$Bong2.play()
		else:
			$Bing1.play()
		
	elif (event.is_action_pressed("ui_right") && !rightPressed):
		$Cinematographer/Camera2D/RightPrompt.frame = 1 #and play a sound
		rightPressed = true
		
		if leftPressed:
			$Bong2.play()
		else:
			$Bing1.play()

	if (leftPressed && rightPressed):
		$Cinematographer.linear_damp = 1
		
		$Tween.interpolate_property(self, "vibradius", vibradius, 0, 2)
		$Tween.start()
		
		$TweenWind.interpolate_property($WindLoop, "volume_db", $WindLoop.volume_db, -50, 2)
		$TweenWind.start()

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




func _on_Alarm_loop():
	$Alarm.play()


func _on_WindLoop_finished():
	$WindLoop.play()
