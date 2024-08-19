extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.cannon_upgrade.connect(_on_EVENTS_cannon_upgrade)
	visible = false

func _on_EVENTS_cannon_upgrade():
	$CannonUpgrade/AnimationPlayer.play("upgrade")
