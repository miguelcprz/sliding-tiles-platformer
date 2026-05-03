extends CheckButton

func _ready() -> void:
	button_pressed = GameManager.sliding_mode_on
	GameManager.sliding_mode_changed.connect(switch_sliding_button)

func switch_sliding_button(is_active : bool) -> void:
	button_pressed = is_active
