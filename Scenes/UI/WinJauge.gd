extends Control

@onready var jauge_mask = $JaugeMask

var MAX_SIZE_Y = 389.0
var MIN_SIZE_Y = 53.0
var MAX_POS_Y = 698.0
var MIN_POS_Y = 1026.0

var monitored_variable : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.freedom_change.connect(on_freedom_meter_change)
	update_display()
	$AnimationPlayer.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_display():
	var diff_y = monitored_variable * (MAX_SIZE_Y-MIN_SIZE_Y) / 10.0
	var new_size = jauge_mask.size
	new_size.y = MIN_SIZE_Y + diff_y
	var new_pos = jauge_mask.position
	new_pos.y = MIN_POS_Y - diff_y
	
	jauge_mask.set_deferred("size",new_size)
	jauge_mask.set_deferred("position",new_pos)

### SIGNAL RESPONSES ###

func on_freedom_meter_change():
	monitored_variable = GAME.freedom_meter
	update_display()
