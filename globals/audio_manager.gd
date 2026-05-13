extends Node

@onready var music: AudioStreamPlayer = %Music
@onready var jump: AudioStreamPlayer = %Jump
@onready var tile_slide: AudioStreamPlayer = %TileSlide
@onready var knockback: AudioStreamPlayer = $Knockback
@onready var door_open: AudioStreamPlayer = $DoorOpen
@onready var whoosh: AudioStreamPlayer = $Whoosh

@onready var jump_timer: Timer = $JumpTimer

func _ready() -> void:
	jump_timer.timeout.connect(restart_jump_counter)

var cut_sceen_ready : bool = false

var jump_counter : int = 0

func play_door_open() -> void:
	door_open.play()

func play_jump() -> void:
	whoosh.play()
	
	if jump_timer.is_stopped():
		jump_timer.start(2.0)
		
	if jump_counter == 2:
		jump.play()
	
	jump_counter += 1
	
	

func play_tile_slide() -> void:
	if cut_sceen_ready == true:
		tile_slide.play()

func play_knockback() -> void:
	knockback.play()

func switch_song(new_song_idx : int) -> void:
	var playback : AudioStreamPlaybackInteractive = music.get_stream_playback()
	var curr_song_idx = playback.get_current_clip_index()
	if new_song_idx == curr_song_idx:
		playback.switch_to_clip(curr_song_idx-1)
	else:
		playback.switch_to_clip(new_song_idx)

func restart_jump_counter() -> void:
	jump_counter = 0
