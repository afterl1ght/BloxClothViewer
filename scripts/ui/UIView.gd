extends Control

class_name UIMain

export(NodePath) var skinModelPath
onready var skinModel : SkinModel = get_node(skinModelPath)
