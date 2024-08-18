extends Control

@onready var jauge_mask = $JaugeMask

var MAX_SIZE_Y = 389.0
var MIN_SIZE_Y = 53.0
var MAX_POS_Y = 698.0
var MIN_POS_Y = 1026.0

var monitored_variable : float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#MAX_SIZE_Y = 1177.0
	#MAX_POS_Y = 698.0
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	monitored_variable -= delta * 10
	monitored_variable = clamp(monitored_variable, 0.0,100.0)
	update_display()

func update_display():
	var diff_y = monitored_variable * (MAX_SIZE_Y-MIN_SIZE_Y) / 100.0
	jauge_mask.size.y = MIN_SIZE_Y + diff_y
	jauge_mask.position.y = MIN_POS_Y - diff_y
