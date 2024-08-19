extends Control

var unit_texture : Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$AudioStreamPlayer2D.pitch_scale = rng.randf_range(0.95,1.05)
	$AudioStreamPlayer2D.play()
	$Sprite2D.texture = unit_texture
	EVENTS.emit_signal("set_shake")
	$GPUParticles2D.emitting = true

