extends Node2D

var source
export(int) var distScale
var allFrame = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("Death", self, "on_death")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var distance = abs(global_position.y - source.global_position.y) - source.radius
	allFrame = 10 - int(floor((10*(1-distance/(1500-source.radius)))))
	
	$Arrow.frame = allFrame

	$Eye.position.y = global_position.y - source.global_position.y

	if ($Arrow.frame <= 0):
		queue_free()

func on_death():
	queue_free()
