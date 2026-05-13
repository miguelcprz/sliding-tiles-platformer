extends VSlider

func _ready() -> void:
	set_value_no_signal(AudioServer.get_bus_volume_linear(0))

func _on_value_changed(volume: float) -> void:
	AudioServer.set_bus_volume_linear(0,volume)
	
func change_visibility () -> void:
	visible = !visible
