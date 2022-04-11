extends TextureButton

export(NodePath) var avtSubButtonPath
onready var avtSubButtons : AvtSubButtons = get_node(avtSubButtonPath)

func _ready():
	pressed = avtSubButtons.isAllInvisible

func _pressed():
	if (avtSubButtons.selectedIndex == -1):
		avtSubButtons.toggleAllVisibility()
	else:
		avtSubButtons.toggleBodyPartVisibility(avtSubButtons.selectedIndex)
	pass

func _process(_dt):
	if (avtSubButtons.selectedIndex == -1):
		pressed = avtSubButtons.isAllInvisible
	else:
		var blockModel = avtSubButtons.getCurrentBlockModel()
		pressed = avtSubButtons.bodyPartInfo[blockModel.name][avtSubButtons.selectedIndex][0]
