extends Camera

const ORIGINAL_FOV = 80
const MIN_FOV = 20
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

var mouseWheelZoomRate := 100
var mousePosBefore := Vector2.ZERO # Use for moving mouse around
var mouseWheelPressing := false
var mouseWheelClickEvent

var unhandled_dragged = false

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

func see_mousemid_movement():
	var mousePosNow = get_viewport().get_mouse_position()
	h_offset += (mousePosBefore.x - mousePosNow.x) * lerp(0.0025, 0.01, (currentfov - MIN_FOV) / (MAX_FOV - MIN_FOV))
	v_offset -= (mousePosBefore.y - mousePosNow.y) * lerp(0.0025, 0.01, (currentfov - MIN_FOV) / (MAX_FOV - MIN_FOV))
	h_offset = clamp(h_offset, -limhoff, limhoff)
	v_offset = clamp(v_offset, -limvoff, limvoff)
	mousePosBefore = mousePosNow

func zoomcam(rate: int):
	self.currentfov += rate * 0.05
	self.currentfov = clamp(currentfov, MIN_FOV, MAX_FOV)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		unhandled_dragged = true
	if event is InputEventScreenTouch and !(event.pressed):
		unhandled_dragged = false
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				zoomcam(-mouseWheelZoomRate)
			# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoomcam(mouseWheelZoomRate)
			if event.button_index == BUTTON_MIDDLE:
				if (!mouseWheelPressing):
					# Just entered camera movin state (works similarly to the one above but with a mouse instead)
					mousePosBefore = event.position
					mouseWheelClickEvent = event
					mouseWheelPressing = true
					
		else:
			if event.button_index == BUTTON_MIDDLE:
				mouseWheelPressing = false
				mouseWheelClickEvent = null

func _input(event) -> void:
	if event is InputEventScreenTouch and event.pressed == true:
		touches[event.index] = {"start":event, "current":event}
	if event is InputEventScreenTouch and event.pressed == false:
		touches.erase(event.index)
	if event is InputEventScreenDrag and touches.size() > 0 and event.index < touches.size() and unhandled_dragged:
		touches[event.index]["current"] = event

func _process(_dt):
	if !mouseWheelPressing:
		see_pinch()
	else:
		see_mousemid_movement()
	
	# Adjust camera FOV to adapt to screen resolution. May drastically change perspective in super narrow devices (?)
	var rectsize = get_viewport().size
	if (rectsize.x / rectsize.y < 0.6):
		self.fovoffset = lerp(MAX_CORRECTION_FOV, 0, (rectsize.x / rectsize.y) / 0.6)
