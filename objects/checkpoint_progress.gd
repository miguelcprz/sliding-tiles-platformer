extends TextureProgressBar
@onready var checkpoint_timer: Timer = $"../CheckpointTimer"

func _physics_process(_delta: float) -> void:
	if checkpoint_timer:
		value = max_value - checkpoint_timer.time_left
