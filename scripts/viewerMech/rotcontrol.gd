extends Spatial

class_name SkinModel

export(NodePath) var blockModelPath
onready var blockModel : MeshInstance = get_node(blockModelPath)

var pressed := false
var indexes = {}

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		indexes[event.index] = true
	if event is InputEventScreenTouch and !(event.pressed):
		indexes.erase(event.index)
		
	if event is InputEventScreenDrag and indexes.size() <= 1:
		rotation.x -= event.relative.y*0.005
		$SkinMain.rotation.y += event.relative.x*0.005

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("viewer_touch_drag"):
		pressed = true
	if Input.is_action_just_released("viewer_touch_drag"):
		pressed = false
