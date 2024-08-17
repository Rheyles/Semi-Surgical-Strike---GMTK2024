extends StaticBody2D

@export var TEAM : DATA.TEAMS

@onready var health_component = $HealthComponent

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = DATA.team_color[TEAM]
	$NavigationObstacle2D.radius = $CollisionShape2D.shape.radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func destroy():
	queue_free()

### LOGIC


### SIGNAL RESPONSES

