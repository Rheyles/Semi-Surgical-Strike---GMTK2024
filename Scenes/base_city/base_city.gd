extends StaticBody2D

@export var TEAM : DATA.TEAMS
@export var UNIT_TYPE : DATA.UNIT_TYPE

@export var sound_spawn : Resource
@export var sound_destruction : Resource


@onready var health_component = $HealthComponent
@onready var sound_player = $AudioStreamPlayer

var waiting_for_destroy : bool = false

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = DATA.team_color[TEAM]
	$Art.visible = true
	$Cross.visible = false
	if TEAM == DATA.TEAMS.ALLY:
		$Art/AnimationPlayer.play("Spawn")
		await $Art/AnimationPlayer.animation_finished
		$Art/AnimationPlayer.play("idle")
	$NavigationObstacle2D.radius = $CollisionShape2D.shape.radius


### Freedom win point on Allied base spawn
	if TEAM == DATA.TEAMS.ALLY:
		GAME.freedom_meter += 1
		print("Freedom : " + str(GAME.freedom_meter))
		GAME.check_freedom_meter()
		### ALLY SFX
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		sound_player.pitch_scale = rng.randf_range(0.95,1.05)
		sound_player.stream = sound_spawn
		sound_player.play()


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
			### ALLY SFX
			sound_player.stream = sound_destruction
			sound_player.play()
	
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()

### LOGIC


### SIGNAL RESPONSES

