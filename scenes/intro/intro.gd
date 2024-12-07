extends Node2D


enum PlayerStateEnum {
	PLAYER_WALKING = 0,
	PLAYER_WALKING_TO_HOLE = 1,
	PLAYER_FALLING_TO_HOLE = 2,
	PLAYER_FALLEN = 3,
	PLAYER_MET_JUDGE = 4,
	PLAYER_MET_COIN = 5
}

const PLAYER_STATE_ENUM_ORDER = [
	PlayerStateEnum.PLAYER_WALKING,
	PlayerStateEnum.PLAYER_WALKING_TO_HOLE,
	PlayerStateEnum.PLAYER_FALLING_TO_HOLE,
	PlayerStateEnum.PLAYER_FALLEN,
	PlayerStateEnum.PLAYER_MET_JUDGE,
	PlayerStateEnum.PLAYER_MET_COIN
]

@onready var _player = $Player
@onready var _next_button = $NextButton
@onready var _skip_intro_button = $SkipIntroButton
@onready var _hit_next_button = $HitNextLabel


func _ready():
	_player.walking()
	_next_button.pressed.connect(_on_next_button_pressed)
	_skip_intro_button.pressed.connect(_on_skip_intro_button_pressed)
	_player.auto_animation_sequence_finished.connect(_on_auto_animation_sequence_finished)


func _on_next_button_pressed():
	var player_animation_played = _player.player_animation().get_animation()
	var player_state_enum = PlayerStateEnum["PLAYER_" + player_animation_played.to_upper()]
	var player_state_enum_order_index = PLAYER_STATE_ENUM_ORDER.find(player_state_enum)

	var next_player_state_enum_order_index = player_state_enum_order_index + 1

	if next_player_state_enum_order_index >= PLAYER_STATE_ENUM_ORDER.size():
		GlobalLevelState.goto_game_scene()
		return

	var next_player_state_enum = PLAYER_STATE_ENUM_ORDER[next_player_state_enum_order_index]
	match next_player_state_enum:
		PlayerStateEnum.PLAYER_WALKING_TO_HOLE:
			_player.walking_to_hole()
		PlayerStateEnum.PLAYER_FALLING_TO_HOLE:
			_player.falling_to_hole()
		PlayerStateEnum.PLAYER_FALLEN:
			_player.fallen()
		PlayerStateEnum.PLAYER_MET_JUDGE:
			_player.met_judge()
		PlayerStateEnum.PLAYER_MET_COIN:
			_player.met_coin()


func _on_skip_intro_button_pressed():
	GlobalLevelState.goto_game_scene()


func _on_auto_animation_sequence_finished():
	_hit_next_button.show()