extends VSlider


func _ready():
	set_value_no_signal(SoundManager.get_bgm_volume_db())


func _value_changed(new_value):
	SoundManager.set_bgm_volume_db(new_value)
	SoundManager.set_bgs_volume_db(new_value)
	SoundManager.set_sfx_volume_db(new_value)
	SoundManager.set_mfx_volume_db(new_value)

	for sound in SoundManager.get_audio_files_dictionary().keys():
		SoundManager.set_volume_db(new_value, sound)
