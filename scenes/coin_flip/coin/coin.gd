class_name Coin
extends RandomPicker

var _player_coin_name = GlobalEnums.COIN.INDEX
var _arrow_keys_control_scene = null
var _coin_side_control_scene = null

@onready var _tails_animation = $TailsAnimatedSprite2D
@onready var _heads_animation = $HeadsAnimatedSprite2D


func _ready():
	var coin_side_control = load(
		"res://scenes/coin_flip/coin/coin_side_control/coin_side_control.tscn"
	)

	_coin_side_control_scene = coin_side_control.instantiate()
	call_deferred("_deferred_add_coin_control", _coin_side_control_scene)
	_reset_animation()


func _deferred_add_coin_control(node):
	get_tree().root.add_child(node)

	_coin_side_control_scene.heads_button.pressed.connect(
		_on_player_picked.bind(GlobalEnums.COIN.HEADS)
	)
	_coin_side_control_scene.tails_button.pressed.connect(
		_on_player_picked.bind(GlobalEnums.COIN.TAILS)
	)


# Show faceless coin before flipping animation
func _reset_animation():
	_tails_animation.hide()
	_heads_animation.set_frame(0)
	_heads_animation.show()


func _show_arrow_keys():
	var arrow_keys_control = load(
		"res://scenes/coin_flip/coin/arrow_keys_control/arrow_keys_control.tscn"
	)
	_arrow_keys_control_scene = arrow_keys_control.instantiate()
	get_tree().root.add_child(_arrow_keys_control_scene)
	_arrow_keys_control_scene.flip_delay_timer.timeout.connect(_get_coin_result)


func _get_coin_result():
	_arrow_keys_control_scene.queue_free()
	for item in item_list:
		if str(item.name) == _player_coin_name:
			item.pick_chance = GlobalLevelState.player_win_rate
		else:
			item.pick_chance = 1 - GlobalLevelState.player_win_rate

	var result_coin_name = pick_random_item()
	var is_successful_throw = result_coin_name == _player_coin_name

	_heads_animation.animation_finished.connect(_on_animation_finished.bind(is_successful_throw))
	_tails_animation.animation_finished.connect(_on_animation_finished.bind(is_successful_throw))

	if result_coin_name == GlobalEnums.COIN.HEADS:
		_tails_animation.hide()
		_heads_animation.set_frame_and_progress(0, 0.0)
		_heads_animation.show()
		_heads_animation.play()

	elif result_coin_name == GlobalEnums.COIN.TAILS:
		_heads_animation.hide()
		_tails_animation.set_frame_and_progress(0, 0.0)
		_tails_animation.show()
		_tails_animation.play()


# TODO: Maybe start the flipping animation but stop midway
# 	so the coin is "midair" during countdown
func _on_player_picked(player_coin_name):
	_player_coin_name = player_coin_name
	_coin_side_control_scene.queue_free()

	_reset_animation()
	_show_arrow_keys()


func _on_animation_finished(is_successful_throw):
	if is_successful_throw:
		if not GlobalLevelState.check_is_last_level():
			var updates_label_text = (
				"+$" + str(GlobalEnums.DEFAULT_REWARD_MONEY) + " compensatory damages"
			)

			GlobalLevelState.set_money(
				GlobalLevelState.money + GlobalEnums.DEFAULT_REWARD_MONEY, updates_label_text
			)

		GlobalCoinEvents.coin_flip_succeeded.emit()
	else:
		GlobalCoinEvents.coin_flip_failed.emit()
