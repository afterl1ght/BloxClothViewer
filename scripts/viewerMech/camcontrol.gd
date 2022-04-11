extends Camera

const ORIGINAL_FOV = 80
const MIN_FOV = 30
const MAX_FOV = 120
const MAX_CORRECTION_FOV = 80
var currentfov = 80 setget setfov
var fovoffset = 0 setget setfovoffset

func setfov(v):
	currentfov = v
	fov = currentfov + fovoffset

func setfovoffset(v):
	fovoffset = v
	fov = currentfov + fovoffset

var touches := {}

# Max HV offset limit
var limhoff := 1 # [-1, 1] limit
var limvoff = 1

var currentRadius := -1
var currentCenter := Vector2.ZERO

func _ready():
	self.currentfov = ORIGINAL_FOV

func see_pinch():
	if touches.size() <= 1:
		currentRadius = -1
		currentCenter = Vector2.ZERO
		return
		
	if (currentRadius == -1):
		# Just entered multi pinchin
		currentRadius = (touches[0].current.position - touches[1].current.position).length()
		currentCenter = (touches[0].current.position + touches[1].current.position)/2
		return
	
	var holdingRadius = (touches[0].current.position - touches[1].current.position).length()
	var holdingCenter = (touches[0].current.position + touches[1].current.position)/2
	h_offset += (currentCenter.x - holdingCenter.x) * lerp(0.0025, 0.01, (currentfov - MIN_FOV) / (MAX_FOV - MIN_FOV))
	v_offset += (holdingCenter.y - currentCenter.y) * lerp(0.0025, 0.01, (currentfov - MIN_FOV) / (MAX_FOV - MIN_FOV))#0.005
	h_offset = clamp(h_offset, -limhoff, limhoff)
	v_offset = clamp(v_offset, -limvoff, limvoff)
	zoomcam(currentRadius - holdingRadius)
	currentRadius = holdingRadius
	currentCenter = holdingCenter

func zoomcam(rate: int):
	self.currentfov += rate * 0.05
	self.currentfov = clamp(currentfov, MIN_FOV, MAX_FOV)

func _input(event) -> void:
	if event is InputEventScreenTouch and event.pressed == true:
		touches[event.index] = {"start":event, "current":event}
	if event is InputEventScreenTouch and event.pressed == false:
		touches.erase(event.index)
	if event is InputEventScreenDrag:
		touches[event.index]["current"] = event

func _process(_dt):
	see_pinch()
	
	# Adjust camera FOV to adapt to screen resolution. May drastically change perspective in super narrow devices (?)
	var rectsize = get_viewport().size
	if (rectsize.x / rectsize.y < 0.6):
		self.fovoffset = lerp(MAX_CORRECTION_FOV, 0, (rectsize.x / rectsize.y) / 0.6)
