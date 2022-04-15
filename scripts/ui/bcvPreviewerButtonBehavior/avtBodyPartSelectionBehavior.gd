extends TextureButton

class_name SmolButts

export(int) var bodyIndex = 0
onready var parent : AvtSubButtons = get_parent()

func _pressed():
	if parent:
		if parent.selectedIndex == bodyIndex:
			parent.selectedIndex = -1
		else:
			parent.selectedIndex = bodyIndex
			
func _process(_dt):
	var currentModel = parent.getCurrentBlockModel()
	if parent.selectedIndex == bodyIndex:
		$SelectCircle.visible = true
	else:
		$SelectCircle.visible = false
		
	if parent.bodyPartInfo[currentModel.name][bodyIndex][0]:
		self_modulate = Color(0.392, 0.392, 0.392, 1)
	else:
		self_modulate = Color(1, 1, 1, 1)
