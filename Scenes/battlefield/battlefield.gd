extends Area2D

@onready var game_timer = $GameTimer

var radius := 0.0

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.add_node_to_battlefield.connect(_on_EVENTS_add_node_to_battlefield)
	
	EVENTS.start_battlefield.connect(_on_EVENTS_start_battlefield)
	
	radius = $CollisionShape2D.shape.radius

func _process(_delta):
	GAME.time_left = game_timer.time_left


### SIGNAL RESPONSES

func _on_EVENTS_add_node_to_battlefield(obj:Node):
	add_child(obj)

func _on_EVENTS_start_battlefield():
	game_timer.timeout.connect(_on_EndTimer_timeout)
	game_timer.start(GAME.end_timer)

func _on_EndTimer_timeout():
	print("End game after 5mn !")
	EVENTS.lose_state.emit(2)
