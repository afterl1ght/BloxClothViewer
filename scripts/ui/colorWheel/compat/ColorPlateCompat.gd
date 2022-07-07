extends Control

# Color plate class that supports compatibility extension for other nodes
class_name ColorPlateCompat

# TODO: Intergrate ColorPlateCompat with the current ColorPlate used for body parts.

signal on_color_changed(newColor)

var selectedColor = Color.white setget set_color
var postready = false

func _ready():
	$Wheel.connect("drag_started", self, "hue_drag_started")
	$Wheel.connect("drag_released", self, "hue_drag_released")
	$Wheel.connect("tapped", self, "hue_tapped")
	$ValueBar.connect("drag_started", self, "value_drag_started")
	$ValueBar.connect("drag_released", self, "value_drag_released")
	$ValueBar.connect("tapped", self, "value_tapped")

func do_post_ready():
	pass

func _process(_dt):
	if !postready:
		postready = true
		do_post_ready()
		set_process(false)

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
	
func set_color(val):
	selectedColor = val
	emit_signal("on_color_changed", val)

func hue_tapped():
	pass

func value_tapped():
	pass
	
func hue_drag_started():
	pass
	
func hue_drag_released():
	pass
	
func value_drag_started():
	pass
	
func value_drag_released():
	pass
