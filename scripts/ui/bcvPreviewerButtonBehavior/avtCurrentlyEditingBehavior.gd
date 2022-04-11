extends TextureRect

export(Array, NodePath) var bodyPartPaths
export(NodePath) var avtSubButtonPath
onready var avtSubButtons : AvtSubButtons = get_node(avtSubButtonPath)
onready var allPartsTexture : Texture = texture
var bodyParts = {}

func _ready():
	if avtSubButtons:
		avtSubButtons.connect("onSelectedIndexChanged", self, "onSelectedIndexChanged")
	
func onSelectedIndexChanged(newIndex):
	if avtSubButtons:
		var children = avtSubButtons.get_children()
		if newIndex == -1:
			texture = allPartsTexture
		else:
			for i in children:
				if i is SmolButts:
					if i.bodyIndex == newIndex:
						texture = i.texture_normal
						break
