extends StaticBody2D

@export var TEAM : DATA.TEAMS

@onready var health_component = $HealthComponent

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = DATA.team_color[TEAM]
	$Art.visible = true
	$Cross.visible = false
	$Art/AnimationPlayer.play("idle")
	$NavigationObstacle2D.radius = $CollisionShape2D.shape.radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func destroy():
	$AttackComponent.active = false
	$FactoryComponent.active = false
	$NavigationObstacle2D.avoidance_enabled = false
	$CollisionShape2D.disabled = true
	if TEAM == DATA.TEAMS.ENEMY:
		GAME.freedom_meter += 5
		GAME.freedom_change.emit()
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()

### LOGIC


### SIGNAL RESPONSES

