extends RigidBody2D

export(int) var sideThrust
export(int) var afterimageThreshold#How fast the player must go to trigger afterimages

export(PackedScene) var afterImage

var hasBoost = false
var prevVel = 0
var justLaunched = false

signal boosting

func _ready():
	Global.player = self #So that others may reference it
	Global.connect("Death", self, "on_death") #So that it knows when it dies(?)

func _process(_delta):
	$AnimatedSprite.rotation = linear_velocity.angle() + PI/2 #Rotate sprite to face
	$Label.text = String(floor(linear_velocity.length())) #Update speedometer
	
	if (justLaunched && linear_velocity.length() > afterimageThreshold): #afterimage
		$AnimatedSprite.play("default")#Play the animation
		justLaunched = false #but not every frame
	
	
func _physics_process(_delta):
	prevVel = linear_velocity.x #Store the velocity in case of a wallbounce
	
	if Input.is_action_pressed("ui_left"): #Player moves left
		apply_central_impulse(Vector2(-sideThrust, 0))
	if Input.is_action_pressed("ui_right"):#Player moves right
		apply_central_impulse(Vector2(sideThrust, 0))

func _input(event): #If the player wants to boost
	if (event.is_action_pressed("ui_up") && hasBoost):
		linear_velocity = Vector2(0, -1200)
		hasBoost = false#Expend boost
		$AnimatedSprite.play("default") #Play afterimages
		emit_signal("boosting")

func _on_collision(body): #Hit something
	if (body.is_in_group("Mines")): #A mine
		body.launch()
		
	elif (body.is_in_group("Walls")): #A wall
		linear_velocity.x = -0.9 * prevVel

func on_death(): #Offscreened
	queue_free()


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()


func _on_frame_changed():
	if ($AnimatedSprite.frame != 0):
		var newImage = afterImage.instance()
		newImage.position = position
		newImage.rotation = $AnimatedSprite.rotation
		
		owner.add_child(newImage)
		newImage.frame = $AnimatedSprite.frame
