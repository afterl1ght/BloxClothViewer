extends TextureButton

class_name ImportNotifier

# TODO: See if Yay and Yee in array is necessary, since the third entry already tries to indicate if import is succeeded or not.
onready var noticeData = {
	# [checkmark or X, status icon, is fail?]
	# yay is success, yee is fail
	"shirt_success": [Preloader.statusnoticeYay, Preloader.statusnoticeShirt, false],
	"pants_success": [Preloader.statusnoticeYay, Preloader.statusnoticePants, false],
	"pantsies_success": [Preloader.statusnoticeYay, Preloader.statusnoticePantsies, false],
	"fail": [Preloader.statusnoticeYee, Preloader.statusnoticeYuck, true],
	"fail_storage": [Preloader.statusnoticeYee, Preloader.statusnoticeStorage, true]
}

var is_tweening = false
var is_shown = false
var stay_duration = 0
var max_stay_duration = 3
var max_fail_stay_duration = 3

#TODO: Correct time needed for the tween to perform.
func submitNotice(noticeName):
	var noticer = noticeData[noticeName]
	
	if !noticer:
		return
	
	$NoticeStatus.texture = noticer[0]
	$NoticePic.texture = noticer[1]
	
	if !is_shown:
		$Tween.stop_all()
		is_tweening = true
		is_shown = true
		$Tween.interpolate_property(self, "rect_position", rect_position, Vector2(-450, rect_position.y), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Tween.interpolate_callback(self, $Tween.get_runtime(), "hold_on_duration", noticer[2])
		$Tween.start()
	else:
		hold_on_duration(noticer[2])
		
func hold_on_duration(is_fail):
	# Put in waiting state
	if is_fail:
		stay_duration = max_fail_stay_duration
	else:
		stay_duration = max_stay_duration
	
	is_tweening = false

func _pressed():
	# Disappears on tap
	stay_duration = 0

func _process(dt):
	# Decreases time needed to wait till there's nomore
	if stay_duration > 0 and is_shown and !is_tweening:
		stay_duration -= dt
	elif is_shown and !is_tweening:
		$Tween.stop_all()
		$Tween.interpolate_property(self, "rect_position", rect_position, Vector2(-800, rect_position.y), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
		$Tween.start()
		is_shown = false
