extends FactoryComponent

@export var freedom_threshold : int = 5


func _physics_process(_delta):
	if GAME.freedom_meter >= freedom_threshold:
		active = true
	else:
		active = false
	super(_delta)
