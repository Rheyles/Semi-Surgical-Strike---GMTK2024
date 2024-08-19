extends Control

var unit_texture : Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = unit_texture
	EVENTS.emit_signal("set_shake")
	$GPUParticles2D.emitting = true

