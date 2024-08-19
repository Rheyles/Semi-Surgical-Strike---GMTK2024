extends Area2D

@onready var game_timer = $GameTimer
@onready var sound_player = $TimerBip

var radius := 0.0

var is_10 : bool = true
var is_60 : bool = true

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.add_node_to_battlefield.connect(_on_EVENTS_add_node_to_battlefield)
	
	EVENTS.start_battlefield.connect(_on_EVENTS_start_battlefield)
	
	radius = $CollisionShape2D.shape.radius

func _process(_delta):
	GAME.time_left = game_timer.time_left
	if GAME.time_left <= 10 && is_10:
		biplast10s()
	elif GAME.time_left <= 20 && is_60:
		bip60s()
	

func bip60s():
	is_60 = false
	sound_player.play()
	await  get_tree().create_timer(0.16).timeout
	sound_player.play()
	await  get_tree().create_timer(0.16).timeout
	sound_player.play()
	
func biplast10s():
	is_10 = false
	while GAME.time_left > 0:
		sound_player.play()
		await  get_tree().create_timer(0.16).timeout

### SIGNAL RESPONSES

func _on_EVENTS_add_node_to_battlefield(obj:Node):
	add_child(obj)

func _on_EVENTS_start_battlefield():
	game_timer.timeout.connect(_on_EndTimer_timeout)
	game_timer.start(GAME.end_timer)

func _on_EndTimer_timeout():
	print("End game after 5mn !")
	EVENTS.end_game.emit(DATA.END_TYPE.DEFEAT_TIMER)
