class_name SongSwitchTrigger extends Area2D

##Defines to which song this trigger will switch.
## 0 represents the first song, and so on.
@export var new_song_index : int = 0

func _ready() -> void:
	body_entered.connect(switch_song)

func switch_song(_body) -> void:
	AudioManager.switch_song(new_song_index)
