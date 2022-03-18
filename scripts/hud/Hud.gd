extends Control


onready var Info = $Info
onready var Damage = $Damage
onready var KillFeed = $KillFeed

onready var killSound = $Kill
onready var hitSound = $Hit
onready var headshotSound = $Headshot


export var PlayerNode: NodePath
var player: Spatial

func _ready():
	player = get_node(PlayerNode)
	EventBus.connect("target_hit", self, "report_hit")
	EventBus.connect("target_destroyed", self, "report_target_destroyed")
	EventBus.connect("target_damaged", self, "report_target_damaged")

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


