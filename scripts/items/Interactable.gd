extends Node

class_name Interactable

func get_text()->String:
	return "F to Interact"

func interact()->void:
	print_debug("Interacted")

func trigger():
	EventBus.emit_signal("interactable_triggered", get_text())

func reset():
	EventBus.emit_signal("interactable_triggered", "")
