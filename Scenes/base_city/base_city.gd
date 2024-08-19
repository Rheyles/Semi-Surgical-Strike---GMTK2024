extends StaticBody2D

@export var TEAM : DATA.TEAMS
@export var UNIT_TYPE : DATA.UNIT_TYPE

@onready var health_component = $HealthComponent

var waiting_for_destroy : bool = false

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = DATA.team_color[TEAM]
	$Art.visible = true
	$Cross.visible = false
	$Art/AnimationPlayer.play("idle")
	$NavigationObstacle2D.radius = $CollisionShape2D.shape.radius
### Freedom win point on Allied base spawn
	if TEAM == DATA.TEAMS.ALLY:
		GAME.freedom_meter += 1
		print("Freedom : " + str(GAME.freedom_meter))
		GAME.check_freedom_meter()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func destroy():
	$AttackComponent.active = false
	$FactoryComponent.active = false
	$NavigationObstacle2D.avoidance_enabled = false
	$CollisionShape2D.disabled = true
	
### Freedom win point on Enemy death optional
	#if TEAM == DATA.TEAMS.ENEMY:
		#GAME.freedom_meter += 5
		#GAME.check_freedom_meter()
### Freedom loose point on Allied death
	if !waiting_for_destroy:
		waiting_for_destroy = true
		if TEAM == DATA.TEAMS.ALLY:
			GAME.freedom_meter -= 1
			print("Freedom : " + str(GAME.freedom_meter))
			GAME.check_freedom_meter()
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()

### LOGIC


### SIGNAL RESPONSES

