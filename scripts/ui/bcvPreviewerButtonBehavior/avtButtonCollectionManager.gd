extends Control

class_name AvtSubButtons

export(NodePath) var uiMainPath
onready var uiMain : UIMain = get_node(uiMainPath)

signal onSelectedIndexChanged(newIndex)
signal on_part_transparency_change(body_part, is_transparent)

var bodyPartButtonIds = {
	# block6: 0, 1, 2, 3, 4, 5 (head torso armL armR legL legR)
}

# Selecting body part
var selectedIndex = -1 setget onSelectedIndex
# All

var genericColor = Color(162, 162, 162)
onready var bodyPartInfo = {
	"block6": [
		#head 0
		[
			#transparency
			false,
			#color
			genericColor,
			#surface id of part
			0,
			#material
			Preloader.blockmatHead6
		],
		#torso 1
		[
			#transparency
			false,
			#color
			genericColor,
			#surface id of part
			3,
			#material
			Preloader.blockmatBody6
		],
		#arm left 2
		[
			#transparency
			false,
			#color
			genericColor,
			#surface id of part
			2,
			#material
			Preloader.blockmatArms6
		],
		#arm right 3
		[
			#transparency
			false,
			#color
			genericColor,
			#surface id of part
			1,
			#material
			Preloader.blockmatArmsRight6
		],
		#leg left 4
		[
			#transparency
			false,
			#color
			genericColor,
			#surface id of part
			4,
			#material
			Preloader.blockmatLegs6
		],
		#leg right 5
		[
			#transparency
			false,
			#color
			genericColor,
			#surface id of part
			5,
			#material
			Preloader.blockmatLegsRight6
		]
	]
}
var isAllInvisible = false
var invisibleCount : int = 0

func onSelectedIndex(value):
	if (value < 0):
		selectedIndex = -1
	else:
		selectedIndex = value
		
	emit_signal("onSelectedIndexChanged", selectedIndex)

func getCurrentBlockModel() -> MeshInstance :
	var blockModel : MeshInstance = null
	if (uiMain and uiMain.skinModel and uiMain.skinModel.blockModel):
		blockModel = uiMain.skinModel.blockModel
	return blockModel

func toggleBodyPartVisibility(partIndex):
	var blockModel : MeshInstance = getCurrentBlockModel()
	
	if (blockModel and bodyPartInfo[blockModel.name]):
		bodyPartInfo[blockModel.name][partIndex][0] = !(bodyPartInfo[blockModel.name][partIndex][0])
		var surfmat = bodyPartInfo[blockModel.name][partIndex][2]
		if (bodyPartInfo[blockModel.name][partIndex][0]):
			# the part is invisible
			blockModel.set_surface_material(surfmat, Preloader.invisibleMat)
			invisibleCount += 1
			emit_signal("on_part_transparency_change", partIndex, true)
			# if a part is invisible, check if every other parts are also invisible.
			if (invisibleCount >= bodyPartInfo[blockModel.name].size()):
				isAllInvisible = true
		else:
			# the part is visible
			blockModel.set_surface_material(surfmat, bodyPartInfo[blockModel.name][partIndex][3])
			invisibleCount -= 1
			emit_signal("on_part_transparency_change", partIndex, false)
			# if a part is visible, this would most likely be false
			isAllInvisible = false
	
	# Correct invisible count just in case
	invisibleCount = clamp(invisibleCount, 0, bodyPartInfo[blockModel.name].size())

func toggleAllVisibility():
	var blockModel : MeshInstance = getCurrentBlockModel()
		
	if not blockModel:
		return
	if isAllInvisible:
		for i in bodyPartInfo[blockModel.name].size():
			var surfmat = bodyPartInfo[blockModel.name][i][2]
			bodyPartInfo[blockModel.name][i][0] = false
			blockModel.set_surface_material(surfmat, bodyPartInfo[blockModel.name][i][3])
			emit_signal("on_part_transparency_change", i, false)
		
		invisibleCount = 0
		isAllInvisible = false
	else:
		# Make all invisible
		for i in bodyPartInfo[blockModel.name].size():
			var surfmat = bodyPartInfo[blockModel.name][i][2]
			bodyPartInfo[blockModel.name][i][0] = true
			blockModel.set_surface_material(surfmat, Preloader.invisibleMat)
			emit_signal("on_part_transparency_change", i, true)
		
		invisibleCount = bodyPartInfo[blockModel.name].size()
		isAllInvisible = true

# This one would require a particular partIndex within the body part quantity
func changeBodyPartColor(partIndex : int, color : Color):
	# update body color
	var blockModel : MeshInstance = getCurrentBlockModel()
	
	if (blockModel and bodyPartInfo[blockModel.name]):
		bodyPartInfo[blockModel.name][partIndex][1] = color # Is this necessary??
		bodyPartInfo[blockModel.name][partIndex][3].set_shader_param("albedo", color)

func changeCurrentBodyPartColor(color : Color):
	var blockModel : MeshInstance = getCurrentBlockModel()
	if selectedIndex < 0: # consider failsafe for >= .size()?
		for bpi in bodyPartInfo[blockModel.name].size():
			changeBodyPartColor(bpi, color)
	else:
		changeBodyPartColor(selectedIndex, color)

func getBodyPartColor(partIndex : int):
	var blockModel : MeshInstance = getCurrentBlockModel()
	
	if (blockModel and bodyPartInfo[blockModel.name]):
		return bodyPartInfo[blockModel.name][partIndex][3].get_shader_param("albedo")
	
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
var proced = false;
func _process(delta):
	if !proced:
		proced = true
		var blockModel : MeshInstance = null
		if (uiMain and uiMain.skinModel and uiMain.skinModel.blockModel):
			blockModel = uiMain.skinModel.blockModel
			
		#print("active mat: ", blockModel.get_surface_material(1).resource_path)
