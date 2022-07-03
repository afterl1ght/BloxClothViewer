extends Node

# block clothing materials
onready var invisibleMat = preload("res://robloxmodels/mat/invisible.tres")

# block r6 materials
onready var blockmatArms6 = preload("res://robloxmodels/mat/blockmat6/blockmatArms6.tres")
onready var blockmatArmsRight6 = preload("res://robloxmodels/mat/blockmat6/blockmatArmsRight6.tres")
onready var blockmatBody6 = preload("res://robloxmodels/mat/blockmat6/blockmatBody6.tres")
onready var blockmatHead6 = preload("res://robloxmodels/mat/blockmat6/blockmatHead6.tres")
onready var blockmatLegs6 = preload("res://robloxmodels/mat/blockmat6/blockmatLegs6.tres")
onready var blockmatLegsRight6 = preload("res://robloxmodels/mat/blockmat6/blockmatLegsRight6.tres")

# clothing materials
onready var blockmatpants = preload("res://robloxmodels/mat/blockmat6/blockmatpants.tres")
onready var blockmatpantsHybrid = preload("res://robloxmodels/mat/blockmat6/blockmatpantsHybrid.tres")
onready var blockmatshirt = preload("res://robloxmodels/mat/blockmat6/blockmatshirt.tres")

# statusNotice
# check and X
onready var statusnoticeYay = preload("res://appassets/texureassets/ui/statusNotice/statusnoticeYay.png")
onready var statusnoticeYee = preload("res://appassets/texureassets/ui/statusNotice/statusnoticeYee.png")

# statusNotice icons
onready var statusnoticePants = preload("res://appassets/texureassets/ui/statusNotice/statusnoticePants.png")
onready var statusnoticePantsies = preload("res://appassets/texureassets/ui/statusNotice/statusnoticePantsies.png")
onready var statusnoticeShirt = preload("res://appassets/texureassets/ui/statusNotice/statusnoticeShirt.png")
onready var statusnoticeYuck = preload("res://appassets/texureassets/ui/statusNotice/statusnoticeYuck.png")
onready var statusnoticeStorage = preload("res://appassets/texureassets/ui/statusNotice/statusnoticeStorage.png")
# bobux time statusNotice
onready var statusnoticeTofu = preload("res://appassets/texureassets/ui/statusNotice/statusnoticeTofu.png")
onready var statusnoticeWtf = preload("res://appassets/texureassets/ui/statusNotice/statusnoticeWhatTheFuck.png")
onready var stasusnoticeThumbsUp = preload("res://appassets/texureassets/ui/statusNotice/statusnoticeBobuxDealLmao.png")
# bobux time extra assets

# statusok and statuswarning icons for clothing texture status
onready var statusok = preload("res://appassets/texureassets/ui/statusNotice/statusok.png")
onready var statuswarning = preload("res://appassets/texureassets/ui/statusNotice/statuswarning.png")

# checkbox
onready var checkboxYes = preload("res://appassets/texureassets/ui/button/buttonCheckboxChecked.png")
onready var checkboxNo = preload("res://appassets/texureassets/ui/button/buttonCheckboxUnchecked.png")

# environment
onready var worldenv = preload("res://default_env.tres")
onready var procsky = preload("res://default_sky.tres")

# grid
onready var gridmat = preload("res://appassets/materialassets/gridsquareFloor.tres")
