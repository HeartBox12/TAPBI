extends Node2D

export(int) var parallaxBuffer #max distance between center of screen and player
export(int) var deathScroll #How far the camera scrolls down on death

var playerDead = true #Whether the player is NOT in play

export(PackedScene) var level #All objects not persistent between runs
var newLevel #For instancing

export(PackedScene) var resetButton #The menu
var newButton #For instancing

var boostCharge = 0 #How much boost the player has. Can go above Max, but is reset.
export(int) var boostMax #How many points is needed to regain boost

var score = 0 #The player's score, for use in $labelList
var highScore = 0 #The player's personal best, for use in $HighList
var audioSetting = -30 #stores the player's volume setting in dB

export(int) var yToCent = 450#READJUST WHEN WINDOW IS RESIZED
export(int) var xToCent = 576/2

var phase = 1 #The phase the player is in. Useful for music transitions
export(int) var thresh1
export(int) var thresh2
export(int) var speedMin #How fast the player must go to get double points

# Unmarked segments should now be called every time $level spawns in again.
func _ready():
	Global.camera = $Camera
	Global.playEvent = $Events/PlayMusic
	Wwise.set_rtpc_id(AK.GAME_PARAMETERS.MUSICVOLUME, 0.05 * 100, Global.playEvent)

func _process(_delta):
	
	#UPDATE BOOSTCHARGE PROGRESS BAR
	
	if !playerDead:
		#When the player is more than halfway up the screen
		if (Global.player.global_position.y < $Camera.global_position.y + parallaxBuffer):
			var diff = int(($Camera.global_position.y + parallaxBuffer) - Global.player.global_position.y)
			#Increase score by the difference and display new number
			if(Global.player.linear_velocity.length() <= speedMin):
				boostCharge += diff
				score += diff
				digColor("Numbers", $Camera/LabelList) #Color labelList orange
			else:
				boostCharge += diff
				score += 2 * diff
				digColor("WhiteNums", $Camera/LabelList) #Color labelList white
			
			if (boostCharge > boostMax): #Maybe add conditional?
				Global.player.hasBoost = true
			
			display(score, $Camera/LabelList)
			
			#Set camera position relative to player
			$Camera.global_position.y = Global.player.global_position.y - parallaxBuffer
			
			if (phase == 1 && score > thresh1):
				$Events/Phase2.post_event()
				
			elif (phase == 2 && score > thresh2):
				$Events/Phase3.post_event()

func display(num, node): #Updates the display when the player scores points
	node.get_node("Ones").frame = int(num) % 10
	node.get_node("Tens").frame = (int(num) % 100) / 10
	node.get_node("Hundreds").frame = (int(num) % 1000) / 100
	node.get_node("Thousands").frame = (int(num) % 10000) / 1000
	node.get_node("Ten_Thous").frame = (int(num) % 100000) / 10000
	node.get_node("Hundred_Thousands").frame = (int(num) % 100000) / 10000
	node.get_node("Millions").frame = (int(num) % 10000000) / 1000000
	
func digColor(anim, node):
	node.get_node("Ones").animation = anim
	node.get_node("Tens").animation = anim
	node.get_node("Hundreds").animation = anim
	node.get_node("Thousands").animation = anim
	node.get_node("Ten_Thous").animation = anim
	node.get_node("Hundred_Thousands").animation = anim
	node.get_node("Millions").animation = anim
#OBSOLETE
#func _on_AudioStreamPlayer_finished(): #function needed to loop the music.
#	$AudioStreamPlayer.play()

func on_boost():
	boostCharge = 0

#--DEATH SEQUENCE BEGINS HERE--

func _on_OOB(body): #OOB stands for Out of Bounds. Player has fallen out of map.
	if(body == Global.player):
		digColor("Numbers", $Camera/LabelList) #Color labelList orange
		
		playerDead = true
		Global.emit_signal("Death")
		$Events/Death.post_event()
		#$Tween.interpolate_property($AudioStreamPlayer, "volume_db", audioSetting, -70, 0.5, 0)
		#$Tween.start()
		die() #HELDUP: Soon to be obsolete

#func _on_FadeAnim_animation_finished(_anim_name): #Completion of fadeout
#	$AudioStreamPlayer.stop()
#	die()

func die(): #Function that executes all the animations common to both death methods.
	$Tween.interpolate_property($Camera, "position", $Camera.position, $Camera.position + Vector2(0, deathScroll), 0.5, 1)
	$Tween.start()

func _on_tween_over(object, _key): #Serves multiple purposes within death sequence.
	#Camera scroll is complete. Checks for highscore, and decides between scoreAssign() and menu().
	if (object == Global.camera): #Camera scroll is complete.
		newLevel.queue_free()
		$Camera/HighList.visible = true #Now out of play, the high score can be shown.
		
		if(highScore < score):
			scoreAssign()
		else:
			menu()
	
	#MARKOUT
	#Fadeout is complete. Stops the audio and triggers die()
	#elif (object == $AudioStreamPlayer):
	#	$AudioStreamPlayer.stop()
	#	die()
	
	elif (object == self): #Celebration of high score has ended.
		menu()

func scoreAssign(): #Celebrates the player's new high score, and triggers menu().
	$Tween.interpolate_method(self, "tweenedScore", highScore, score, 1) #FIXME: not working yet
	$Tween.start()
	highScore = score
	#menu() #MARKOUT

func menu(): #Creates a menu. Pressing the menu will trigger reset().
	display(highScore, $Camera/HighList)
	
	newButton = resetButton.instance()
	add_child(newButton)
	newButton.get_node("Reset").connect("pressed", self, "reset")
		
	newButton.rect_position = Global.camera.position + Vector2(-xToCent, -yToCent)
		
	newButton.get_node("VSlider").value = db2linear(audioSetting)

func reset(): #Reset button has been pressed. Despawns menu node and invises highList
	$Camera/HighList.visible = false
	$LevelSpawnTimer.start()
	audioSetting = linear2db(newButton.get_node("VSlider").value)
	newButton.queue_free()

func _on_LevelSpawnTimer_timeout():
	$LevelSpawnTimer.wait_time = 0.5 #Set the wait time lower than it was the first time
	
	$Events/Phase1.post_event() #Reset music to Phase 1
	
	score = 0 #Reset score
	
	#$AudioStreamPlayer.play() #MARKOUT
	$AudioStreamPlayer.volume_db = audioSetting
	newLevel = level.instance()
	add_child(newLevel)
	
	newLevel.position = $Camera.position + Vector2(-xToCent,-yToCent)
	playerDead = false
	Global.player.connect("boosting", self, "on_boost")
	
	$AudioStreamPlayer.play()

func tweenedScore(value): #Exists to be tweened
	display(value, $Camera/HighList)

#--DEATH SEQUENCE OVER
