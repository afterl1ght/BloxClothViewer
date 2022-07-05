extends TextureButton

var bubbleremainingTime = 0
var bubbletime = 8 # must be more than appearing time since it adds to bubbleremainingTime too
var bubbleVisible = true

func _ready():
	$bubble.connect("pressed", self, "bubble_pressed")

func bubble_pressed():
	print($bubble.modulate.a)
	if $bubble.modulate.a > 0:
		bubbleremainingTime = 0
		$bubble/Tween.stop_all()
		$bubble/Tween.interpolate_property($bubble, "modulate", $bubble.modulate, Color($bubble.modulate.r, $bubble.modulate.g, $bubble.modulate.b, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$bubble/Tween.start()

func _pressed():
	if bubbleremainingTime == 0 and !bubbleVisible:
		# appear
		$bubble.mouse_filter = Control.MOUSE_FILTER_STOP
		bubbleVisible = true
		$bubble.visible = true
		$bubble/Tween.stop_all()
		$bubble/Tween.interpolate_property($bubble, "modulate", $bubble.modulate, Color($bubble.modulate.r, $bubble.modulate.g, $bubble.modulate.b, 1), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$bubble/Tween.start()
		
	bubbleremainingTime = bubbletime

func _process(_dt):
	if bubbleremainingTime > 0 and bubbleVisible:
		bubbleremainingTime -= _dt
	elif bubbleVisible:
		# disappear
		$bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bubbleVisible = false
		bubble_pressed()
