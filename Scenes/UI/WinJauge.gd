extends Control

@onready var jauge_mask = $JaugeMask

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	jauge_mask.size.y -= delta * 10
	jauge_mask.position.y +=  delta * 10
