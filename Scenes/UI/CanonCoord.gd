extends Control

@export var canon : Node

@onready var lat = $Lat
@onready var lon = $Lon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	lat.text = "LAT \\ " + str(snapped(canon.global_position.x*1000,0.1)/100)
	lon.text = "LON \\ " + str(snapped(canon.global_position.y*1000,0.1)/100)
