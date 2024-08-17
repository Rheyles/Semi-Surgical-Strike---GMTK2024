extends StaticBody2D

@export var TEAM : DATA.TEAMS
@export var UNIT_SCENE : Resource

@onready var health_component = $HealthComponent

@onready var unit_creation_timer = $UnitCreationTimer

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	$NavigationObstacle2D.radius = $CollisionShape2D.shape.radius
	
	unit_creation_timer.timeout.connect(_on_UnitCreationTimer_timeout)
	unit_creation_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func destroy():
	queue_free()

### LOGIC

func create_unit():
	var new_unit = UNIT_SCENE.instantiate()
	new_unit.TEAM = TEAM
	EVENTS.emit_signal("add_node_to_battlefield", new_unit)
	new_unit.global_position = global_position

### SIGNAL RESPONSES

func _on_UnitCreationTimer_timeout():
	create_unit()
	unit_creation_timer.start()
