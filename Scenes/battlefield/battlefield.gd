extends Area2D

var radius := 0.0

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.add_node_to_battlefield.connect(_on_EVENTS_add_node_to_battlefield)
	
	radius = $CollisionShape2D.shape.radius


### SIGNAL RESPONSES

func _on_EVENTS_add_node_to_battlefield(obj:Node):
	add_child(obj)
