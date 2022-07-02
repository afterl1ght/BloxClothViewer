extends TextureButton

class_name PicHitbox

# ImportNotifier class path
export(NodePath) var notifierMasterPath
onready var notifierMaster : ImportNotifier = get_node(notifierMasterPath)

export(NodePath) var eventBobuxPath
onready var eventBobux : EventOrganizer = get_node(eventBobuxPath)

func _pressed():
	if notifierMaster:
		if notifierMaster.bobuxTime:
			# BOBUX TIME
			notifierMaster.bobuxTime = false
			notifierMaster.submitNotice("witch_deal", false)
			eventBobux._run_event()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if notifierMaster:
		if notifierMaster.bobuxTime:
			mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
