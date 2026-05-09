class_name SliderTriggerPrompt extends Sprite2D

@export var this_trigger : PortraitTrigger

func _ready() -> void:
	hide()
	if not this_trigger:
		this_trigger = get_parent()
	
	this_trigger.body_entered.connect(show_prompt)
	this_trigger.body_exited.connect(hide_prompt)

func show_prompt(_body) -> void:
	show()

func hide_prompt(_body) -> void:
	hide()
