extends NinePatchRect
# warnings-disable

@onready var label = $Content/Label

var timer_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.start_battlefield.connect(_on_EVENTS_start_battlefield)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if timer_started:
		var seconds_left = int(GAME.time_left)%60
		var seconds_text = str(seconds_left)
		if seconds_left < 10:
			seconds_text = '0' + str(seconds_left)
		label.text = '0'+str(round(int(GAME.time_left)/60)) + ':' + seconds_text


func _on_EVENTS_start_battlefield():
	timer_started = true
