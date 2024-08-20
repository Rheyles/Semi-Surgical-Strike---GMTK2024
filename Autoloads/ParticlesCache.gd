extends CanvasLayer

var shoot_debris_part = preload("res://Ressources/Materials/shoot_debris_part.tres")
var shoot_flash_part = preload("res://Ressources/Materials/shoot_flash_part.tres")
var shoot_smoke_part = preload("res://Ressources/Materials/shoot_smoke_part.tres")
var shoot_spark_part = preload("res://Ressources/Materials/shoot_spark_part.tres")
var shoot_trace_part = preload("res://Ressources/Materials/shoot_trace_part.tres")


var materials = [
	shoot_debris_part
	,shoot_flash_part
	,shoot_smoke_part
	,shoot_spark_part
	,shoot_trace_part
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for material in materials:
		var particle_instance = GPUParticles2D.new()
		particle_instance.set_process_material(material)
		particle_instance.one_shot = true
		particle_instance.emitting = true
		self.add_child(particle_instance)
		
