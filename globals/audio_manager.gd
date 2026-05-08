extends Node

@onready var music: AudioStreamPlayer = %Music
@onready var jump: AudioStreamPlayer = %Jump
@onready var tile_slide: AudioStreamPlayer = %TileSlide



func play_jump() -> void:
	jump.play()

func play_tile_slide() -> void:
	tile_slide.play()

func switch_song(new_song_idx : int) -> void:
	var playback : AudioStreamPlaybackInteractive = music.get_stream_playback()
	var curr_song_idx = playback.get_current_clip_index()
	if new_song_idx == curr_song_idx:
		playback.switch_to_clip(curr_song_idx-1)
	else:
		playback.switch_to_clip(new_song_idx)
	
	
