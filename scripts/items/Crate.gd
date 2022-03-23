extends Interactable


func get_text()->String:
	return "F to get a Mag"

func interact()->void:
	print_debug("interacted")
	EventBus.emit_signal("mags_pickup", 1, WeaponEnums.TYPES.NONE)
