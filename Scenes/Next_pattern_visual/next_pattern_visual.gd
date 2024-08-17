extends Node2D

var canonNode_array =  []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_node("Node_Container").get_child_count():
		var node = get_node("Node_Container").get_child(i)
		canonNode_array.append(node)
