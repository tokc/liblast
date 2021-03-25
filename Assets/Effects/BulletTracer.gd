extends Spatial

var first = true
var velocity = 4

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if first:
		translate_object_local(Vector3(- rand_range(0, velocity) - velocity*3 ,0 ,0))
		first = false
	else:
		translate_object_local(Vector3(-velocity,0,0))

func _on_Raycast_body_entered(_body):
	#print("Tracer died:", body)
	queue_free()
