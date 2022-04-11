extends BCVPreviewerButton

# name of body like "head", "torso", "legR",...


export(NodePath) var avtSubPlatePath
onready var avtSubPlate : AvtSubButtons = get_node(avtSubPlatePath)
var subplateTween : Tween

const TOGGLE_EASING_TIME = 0.5

func _ready():
	if avtSubPlate:
		avtSubPlate.connect("on_part_transparency_change", self, "on_part_transparency_change")
		subplateTween = avtSubPlate.get_node("Tween")

var bodyPartNames = [
	# place these in the order of body part ids
	"Head", # starting from 0
	"Torso", # 1,...
	"ArmL",
	"ArmR",
	"LegL",
	"LegR"
]
func on_part_transparency_change(bodyIndex, transparent):
	var bodyNullLayer = $No.get_node(bodyPartNames[bodyIndex]);
	if (bodyNullLayer) and (bodyNullLayer is TextureRect):
		bodyNullLayer.visible = transparent

func _toggled(button_pressed):
	if avtSubPlate and subplateTween:
		if button_pressed:
			avtSubPlate.selectedIndex = -1
			subplateTween.stop_all()
			subplateTween.interpolate_property(avtSubPlate, "rect_position", avtSubPlate.rect_position, Vector2(0, avtSubPlate.rect_position.y), TOGGLE_EASING_TIME, Tween.TRANS_QUAD, Tween.EASE_OUT)
			subplateTween.start()
		else:
			subplateTween.stop_all()
			subplateTween.interpolate_property(avtSubPlate, "rect_position", avtSubPlate.rect_position, Vector2(350, avtSubPlate.rect_position.y), TOGGLE_EASING_TIME, Tween.TRANS_QUAD, Tween.EASE_IN)
			subplateTween.start()
