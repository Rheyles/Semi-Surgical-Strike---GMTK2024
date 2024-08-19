extends Control

@onready var texture = $TextureRect
@onready var combo_counter = $TextureRect/Count
@onready var timer = $ComboTimer

var combo = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	EVENTS.last_shot_kill.connect(_on_EVENTS_last_shot_kill)
	timer.timeout.connect(_on_Timer_timeout)


func _on_EVENTS_last_shot_kill(nb:int):
	combo += nb
	timer.start()
	if combo > 5:
		combo_counter.text = str(combo)
		$AnimationPlayer.play("pop")

func _on_Timer_timeout():
	combo = 0
