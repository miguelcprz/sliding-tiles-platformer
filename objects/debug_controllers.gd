extends Control

@onready var player: Player

@onready var speed_label: Label = $SpeedLabel
@onready var gravity_label: Label = $GravityLabel
@onready var jump_label: Label = $JumpLabel


@onready var speed_slider: VSlider = $SpeedSlider
@onready var gravity_slider: VSlider = $GravitySlider
@onready var jump_force_slider: VSlider = $JumpForceSlider

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	speed_slider.set_value_no_signal(DevMode.speed)
	speed_label.text = "speed\n%d"%DevMode.speed
	
	gravity_slider.set_value_no_signal(DevMode.gravity)
	gravity_label.text = "gravity\n%d"%DevMode.gravity
	
	jump_force_slider.set_value_no_signal(DevMode.jump_force)
	jump_label.text = "jump\n%d"%DevMode.jump_force
	
func _on_speed_slider_value_changed(value: float) -> void:
	DevMode.speed = int(value)
	speed_label.text = "speed\n%d"%value

func _on_gravity_slider_value_changed(value: float) -> void:
	DevMode.gravity = int(value)
	gravity_label.text = "gravity\n%d"%value

func _on_jump_force_slider_value_changed(value: float) -> void:
	DevMode.jump_force = int(value)
	jump_label.text = "jump\n%d"%value
