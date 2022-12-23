extends StaticBody2D

var active = false
export(int)var minDistance = 50
export(int) var strength = 30000

export(int) var radius = 111 #Radius of HUD circle
export(int) var lineMarginLength = 20 #How far away the distance meter is
export(int) var lineUnderLength = 40 #How long the line under the distance meter is
export(int) var textHeight #how far above the line the text is

var fromplayer = Vector2(0,0)
var playerDead = false

signal det

var sploding = false

func _ready():
	Global.connect("Death", self, "on_death")
	$Splode.volume_db = Global.audioSetting

func _process(_delta):
	if !playerDead: #If there is a player to reference
		fromplayer = global_position - Global.player.global_position
		
		if active:
			var frameInt = (Global.player.global_position - global_position).length() - 25 #Fetch distance to player
			frameInt = int((frameInt / 8))
			
			frameInt = 8 - frameInt
			
			$AnimatedSprite.frame = frameInt
		
		$HUDLines.position = (fromplayer).normalized() * radius
		$HUDLines.points[1] = (fromplayer).normalized() * lineMarginLength
	
	#right side
	if($HUDLines.position.angle() > Vector2.DOWN.angle() || $HUDLines.position.angle() < Vector2.UP.angle()):
		$HUDLines.points[2] = $HUDLines.points[1] + Vector2(-lineUnderLength, 0) #line draw
		$HUDLines/Meter.rect_position = $HUDLines.points[1] + Vector2(-lineUnderLength, -textHeight) #Text draw
	#left side
	else:
		$HUDLines.points[2] = $HUDLines.points[1] + Vector2(lineUnderLength ,0)
		$HUDLines/Meter.rect_position = $HUDLines.points[1] + Vector2(-lineUnderLength, -textHeight)
		$HUDLines/Meter.rect_position = $HUDLines.points[1] + Vector2(0, -textHeight) #Text draw
	
	if !playerDead: #If the player is alive
		$HUDLines/Meter.text = String(floor(fromplayer.length())) + " m"

func _input(event):
	if (active && event.is_action_pressed("ui_accept")):
		launch()
		emit_signal("det")

func _on_Area2D_body_entered(body):
	if (body == Global.player):
		active = true
		$AnimatedSprite.animation = "Arming"
		$AnimatedSprite.stop()


func _on_Area2D_body_exited(body):
	if (body == Global.player):
		active = false
		$AnimatedSprite.play("Idle")

func launch():
	var distance = (fromplayer).length()
	if (distance < minDistance):
		distance = minDistance
		
	var launchvec = (-fromplayer).normalized() * (strength / distance)
	
	#Global.player.linear_velocity = Vector2(0, 0)
	Global.player.apply_central_impulse(launchvec)
	
	active = false
	$Area2D.monitoring = false
	
	if (randi() % 2 == 1): #Randomly play one of two anims
		$AnimatedSprite.play("Det2-1")
	else:
		$AnimatedSprite.play("Det2-2")
		
	collision_layer = 0
	collision_mask = 0
	
	$HUDLines.visible = false
	
	$Splode.play()
	sploding = true
	
	if !(Global.player.get("justLaunched") == null):
		Global.player.justLaunched = true

#func _on_sprite_loop(): #REPLACE WITH AUDIOSTREAMPLAYER TRIGGER
#	if ($AnimatedSprite.animation == "Det2-1" || $AnimatedSprite.animation == "Det2-2"):
#		queue_free()

func _on_offscreen():
	if !sploding:
		queue_free()

func on_death():
	playerDead = true
	$HUDLines/Meter.text = "x"


func _on_Splode_finished():
	queue_free()
