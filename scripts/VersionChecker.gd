extends Control

class_name UpdateUI

export(bool) var is_release = false
export(NodePath) var overlayPath
var overlay : Overlay

var updateChecked = false
var retries = 0
var max_retries = 3
var retry_after_seconds = 0
var retry_seconds_max = 10

var new_update_notif_time = 10
var new_update_notif_appear := false setget new_update_notif_active

var version_name = ""

const version_search_key = "([^v-]*)-([^-0-9]*)(\\d*)" # using tags from releases
const version_type_atlas_location = { # entry: [rect2, xmargin]
	"beta": [Rect2(50, 0, 110, 50),0,"b"],
	"alpha": [Rect2(48, 57, 127, 43),0,"a"],
	"release": [Rect2(23, 109, 179, 51),-30,""],
	"patch": [Rect2(48, 165, 131, 40),-5,"f"], # stands for fix, for emergency fixes, too lazy to update font
	"betapatch": [Rect2(48, 165, 131, 40),-5,"bf"],
	"alphapatch": [Rect2(48, 165, 131, 40),-5,"af"],
	
	"b": [Rect2(50, 0, 110, 50),0,"b"],
	"a": [Rect2(48, 57, 127, 43),0,"a"],
	"f": [Rect2(48, 165, 131, 40),-5,"f"],
	"bf": [Rect2(48, 165, 131, 40),-5,"bf"],
	"af": [Rect2(48, 165, 131, 40),-5,"af"],
}
const version_type_fullname = {
	"beta": "b",
	"alpha": "a",
	"release": "release",
	"patch": "f",
	"betapatch": "bf",
	"alphapatch": "af",
	
	"b": "beta",
	"a": "alpha",
	"f": "patch",
	"bf": "betapatch",
	"af": "alphapatch",
}

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	overlay = get_node(overlayPath)

func _process(dt):
	version_name = ProjectSettings.get_setting("application/config/version_name")
	if !version_name:
		retries = max_retries
		# No reason to retry since we don't know the built-in version name.
	
	if new_update_notif_time > 0 and new_update_notif_appear == true:
		new_update_notif_time -= dt
		if new_update_notif_time <= 0:
			self.new_update_notif_appear = false
	
	if retries >= 3:
		if !new_update_notif_appear:
			set_process(false)
		return
		
	if !updateChecked:
		if retry_after_seconds > 0:
			retry_after_seconds -= dt
		else:
			retry_after_seconds = 0
			updateChecked = true
			$HTTPRequest.request("https://api.github.com/repos/afterl1ght/bloxclothviewer/releases")

func new_update_notif_active(v):
	new_update_notif_appear = v
	if v:
		$NewUpdate/Tween.stop_all()
		$NewUpdate/Tween.interpolate_method($NewUpdate, "update_appearance", 0, 1, 0.5, 10, 1)
		$NewUpdate/Tween.start()
	else:
		$NewUpdate/Tween.stop_all()
		$NewUpdate/Tween.interpolate_method($NewUpdate, "update_appearance", 1, 0, 0.5, 10, 0)
		$NewUpdate/Tween.start()

func notify_update(versionNumber, versionType, versionStage, isPrerelease, releaseUrl):
	var suffix = ""
	var vType = "patch" #default
	if (!isPrerelease and versionType != "patch" and versionType != "f"):
		vType = "release"
	else:
		if versionType in version_type_atlas_location:
			vType = versionType
			suffix = version_type_atlas_location[vType][2] + str(versionStage)
	if !Preloader.versionTypeAtlas:
		return
	
	Preloader.versionTypeAtlas.region = version_type_atlas_location[vType][0]
	Preloader.versionTypeAtlas.margin = Rect2(version_type_atlas_location[vType][1], 0, 0, 0)
	$NewVersionUI/VersionNumber.text = versionNumber + suffix
	if releaseUrl:
		$NewVersionUI.newReleaseLink = releaseUrl
	
	self.new_update_notif_appear = true
	print("update notified")

func on_new_update_tap():
	if overlay:
		overlay.activate()
	$NewVersionUI/Tween.stop_all()
	$NewVersionUI/Tween.interpolate_method($NewVersionUI, "update_appearance", -1, 0, 0.75, 4, 1)
	$NewVersionUI/Tween.start()

func _on_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		retries += 1
		retry_after_seconds = retry_seconds_max
		updateChecked = false
		print("http request failed, retrying")
		return
	print("get success")
	
	var json = JSON.parse(body.get_string_from_utf8())
	if json.error != OK:
		retries += 1
		retry_after_seconds = retry_seconds_max
		updateChecked = false
		print("json failed, retrying")
	else:
		if json.result is Array:
			for release in json.result:
				print("checking some latest releases...")
				# start looping through array of current releases
				if release is Dictionary:
					if release["tag_name"]:
						print(release["tag_name"])
						if release["tag_name"] == ("v" + version_name):
							# You would most likely not encounter this tag if the current release is latest.
							break
						if (!is_release) or (is_release and not release["prerelease"]):
							print("release type approved")
							# Release versions should check for release updates. Prereleases check for both prereleases and releases.
							var regex = RegEx.new()
							regex.compile(version_search_key)
							var version_data = regex.search(release["tag_name"])
							if version_data:
								if version_data.get_group_count() >= 2:
									# Check if it's the same version (with different name identifications)
									if version_data.get_group_count() >= 3:
										if (version_data.get_string(2) in version_type_atlas_location): # if get_string(2) is in atlas location dictionary -> it's also in version_type_fullname
											# this hideous version naming convention should be kept unchanged for now
											if ( version_name == (version_data.get_string(1) + "-" + version_data.get_string(2) + version_data.get_string(3)) ) or ( version_name == (version_data.get_string(1) + "-" + version_type_fullname[version_data.get_string(2)] + version_data.get_string(3)) ):
												# same version, don't care about other updates.
												break
										print("update available 3")
										notify_update(version_data.get_string(1), version_data.get_string(2), version_data.get_string(3), release["prerelease"], release["html_url"])
										break
									else:
										if ( version_name == (version_data.get_string(1) + "-" + version_data.get_string(2)) ) or ( version_name == (version_data.get_string(1) + "-" + version_type_fullname[version_data.get_string(2)]) ):
											# same version, don't care about other updates.
											break
										print("update available 2")
										notify_update(version_data.get_string(1), version_data.get_string(2), "1", release["prerelease"], release["html_url"])
										break
								else:
									continue
							else:
								continue
						else:
							print("release type disapproved, skipping")
							continue
		print("check success")
		retries = max_retries # success, don't check anymore
