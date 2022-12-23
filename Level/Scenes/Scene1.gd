extends Node2D

export(PackedScene) var next

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = $TutPlayer

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		$SpacePrompt.frame = 1
		$LaunchPause.start()


func _on_LaunchPause_timeout():
	get_tree().change_scene_to(next) #Switch to next scene


func _on_windLoop_finished():
	$windLoop.play()
