extends Control

class_name ColorPlate

signal on_color_changed(newColor)

var selectedColor = Color.white setget on_body_color_changed

onready var parent : AvtSubButtons = get_parent()
var postready = false

# If this is true, "All" option will have the same color as Head (but changes the entire body color in that mode)
var allPartsSameColor = false

func _ready():
	parent.connect("onSelectedIndexChanged", self, "on_selected_index_changed")
	
func check_same_color():
	var bpi = parent.bodyPartInfo[parent.getCurrentBlockModel().name]
	var previousColor = null
	var allTheSame = true
	for bp in bpi.size():
		var currentBodyColor = parent.getBodyPartColor(bp)
		if !previousColor or (currentBodyColor == previousColor):
			previousColor = currentBodyColor
		else:
			# Previous color is different. All is dismissed
			allTheSame = false
			break
	
	allPartsSameColor = allTheSame
	
var isChangingIndex = false
func on_selected_index_changed(index):
	isChangingIndex = true
	
	if index == -1:
		check_same_color()
		
	var bpcolor = Color.white
	# Could've just clamped index to 0, but that'll be kinda funny in some cases
	if allPartsSameColor:
		bpcolor = parent.getBodyPartColor(0)
		set_color_to_wheel(bpcolor)
		self.selectedColor = bpcolor
	else:
		if index < 0:
			set_color_to_wheel(bpcolor)
			self.selectedColor = bpcolor
		else:
			bpcolor = parent.getBodyPartColor(index)
			set_color_to_wheel(bpcolor)
			self.selectedColor = bpcolor
			
	isChangingIndex = false

func _process(_dt):
	if !postready:
		postready = true
		on_selected_index_changed(parent.selectedIndex)

func to_hsv(color: Color) -> Array:
	var minRGB = min(color.r, min(color.g, color.b))
	var maxRGB = max(color.r, max(color.g, color.b))
	var diff = maxRGB - minRGB
	
	var hue = 0
	var sat = 0
	if diff != 0:
		if maxRGB == color.r:
			print("r")
			hue = (60 * (color.g - color.b)/diff + 360)
			var hrem : float = hue - int(hue)
			hue = int(hue) % 360
			hue = float(hue) + hrem
		elif maxRGB == color.g:
			print("g")
			hue = (60 * (color.b - color.r)/diff + 120)
			var hrem : float = hue - int(hue)
			hue = int(hue) % 360
			hue = float(hue) + hrem
		elif maxRGB == color.b:
			print("b")
			hue = (60 * (color.r - color.g)/diff + 240)
			var hrem : float = hue - int(hue)
			hue = int(hue) % 360
			hue = float(hue) + hrem
			
	if (maxRGB != 0):
		sat = float(diff)/maxRGB
	return [(deg2rad(hue)), sat, maxRGB] # hsv

func set_color_to_wheel(color):
	# Calculate angle => position of the wheel selection point
	var hsv = to_hsv(color)
	var huereal = hsv[0] - PI/2 # hue value minus 90deg from positive x axis
	# set selection position based on hsv
	$Wheel/Selection.rect_position = $Wheel.middle + Vector2(cos(huereal), sin(huereal)).normalized() * ($Wheel.max_dist * hsv[1])
	$ValueBar.set_value_height_scale(hsv[2])
	
func on_body_color_changed(val):
	if !isChangingIndex:
		parent.changeCurrentBodyPartColor(val)
		check_same_color()
	emit_signal("on_color_changed", val)
