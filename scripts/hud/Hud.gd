extends Control


onready var Info = $Info
onready var Damage = $Damage
onready var KillFeed = $KillFeed
onready var Ammo = $Ammo
onready var Mags = $Mags

onready var killSound = $Kill
onready var hitSound = $Hit
onready var headshotSound = $Headshot


export var PlayerNode: NodePath
var player: Spatial
var player_mags = null
var weaponType = WeaponEnums.TYPES.NONE

func _ready():
	player = get_node(PlayerNode)
	EventBus.connect("target_hit", self, "report_hit")
	EventBus.connect("target_destroyed", self, "report_target_destroyed")
	EventBus.connect("target_damaged", self, "report_target_damaged")
	EventBus.connect("mag_update", self, "report_mag_update")
	EventBus.connect("weapon_switch", self, "report_weapon_switch")
	EventBus.connect("player_mags_update", self, "update_player_mags")

func report_hit(distance):
	Info.text = "%d m" % distance
	hitSound.play()
	$Info/Timer.start()

func report_target_destroyed(is_headshot):
	KillFeed.text = "Killed"
	killSound.play()
	if is_headshot:
		KillFeed.text += " (Headshot)"
	$KillFeed/Timer.start()

func report_target_damaged(dmg, is_headshot):
	Damage.text = "dmg %d" % dmg
	if is_headshot:
		Damage.text += " HEADSHOT"
		headshotSound.play()
	$Damage/Timer.start()

func report_mag_update(type, bullets, starting_bullets):
	print_debug("mag up", type, bullets, starting_bullets)
	Ammo.text = "%d / %d" % [bullets, starting_bullets]

func update_player_mags(mags = null):
	if mags != null:
		player_mags = mags
	
	if weaponType != WeaponEnums.TYPES.NONE:
		Mags.text = "Mags: %d " % player_mags[weaponType].count

func report_weapon_switch(type):
	weaponType = type
	if player_mags != null:
		update_player_mags()


