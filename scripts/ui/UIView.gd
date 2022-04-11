extends Control

class_name UIMain

export(NodePath) var skinModelPath
onready var skinModel : SkinModel = get_node(skinModelPath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
