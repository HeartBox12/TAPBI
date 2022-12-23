extends Node2D

export(PackedScene) var obstacle
export(PackedScene) var warn

export(int) var camBuffer #distance of spawns above camera
export(int) var spawnBuffer #distance between spawns

var ytocent = 450
var xtocent = 576/2

var prevPos = xtocent #The x-coord of the most recently spawned mine
export(int) var lateralGap #How close (x-coord-wise) new mines are allowed to spawn to the prev one

func _ready():
	seed(Time.get_ticks_usec())
	#$SpawnLooper.position = Global.camera.global_position

func _process(_delta):
	if (Global.camera.global_position.y < $SpawnLooper.global_position.y): #If the camera has risen above the pos2D.
		$SpawnLooper.position.y -= spawnBuffer
		spawn()

func spawn(): #Create and place new mine --MARK--
	var pos = randi() % int(get_viewport().get_visible_rect().size.x)
	
	while (abs(pos - prevPos) < lateralGap):
		pos = randi() % int(get_viewport().get_visible_rect().size.x)
	
	var newObs = obstacle.instance()
	add_child(newObs)
	newObs.global_position = Vector2(pos, Global.camera.global_position.y - camBuffer)
	newObs.connect("det", self, "on_det")
	
	var newWarn = warn.instance() #Create new instance
	Global.camera.add_child(newWarn) #Set to move with camera
	#position RELATIVE TO CAMERA at top of screen
	newWarn.position = Vector2(newObs.position.x - xtocent, -ytocent + 20)
	
	newWarn.source = newObs #Allow warn to reference newObs' data
	
	prevPos = pos #Record x-pos for next instance to avoid

func on_det():
	$AudioStreamPlayer.play()
