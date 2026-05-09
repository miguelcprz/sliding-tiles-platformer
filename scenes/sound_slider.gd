extends HSlider

func _ready() -> void:
	set_value_no_signal(AudioServer.get_bus_volume_linear(0))

func _on_value_changed(level: float) -> void:
	AudioServer.set_bus_volume_linear(0,level)
