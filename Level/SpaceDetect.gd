extends Control

# Called when the node enters the scene tree for the first time.
func _input(event):
	if(event.is_action_pressed("ui_accept")):
		$Reset.emit_signal("pressed")
		Global.audioSetting = linear2db($VSlider.value)




func _on_slid(value):
	Wwise.set_rtpc_id(AK.GAME_PARAMETERS.MUSICVOLUME, $VSlider.value * 100, Global.playEvent)
	
	if (value == 0):
		$VSlider/SoundIcon.frame = 1
	else:
		$VSlider/SoundIcon.frame = 0


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("default")
