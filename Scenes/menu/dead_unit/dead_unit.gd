extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.emit_signal("set_shake")
	$GPUParticles2D.emitting = true

