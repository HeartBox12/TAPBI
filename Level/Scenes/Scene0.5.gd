extends Node2D

var tracker = 0
export(PackedScene) var next

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _proceed():
	match tracker:
		0:
			$Tween.interpolate_property($First, "visible_characters", 0, $First.text.length(), float($First.text.length())/45)
			$Tween.start()
		1:
			$Tween.interpolate_property($Second, "visible_characters", 0, $Second.text.length(), float($Second.text.length())/45)
			$Tween.start()
		2:
			get_tree().change_scene_to(next)
	
	tracker += 1

func _on_Tween_up():
	$DramaticPause.start()
