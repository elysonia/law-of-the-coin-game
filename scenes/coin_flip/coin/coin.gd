class_name Coin
extends RandomPicker

var _arrow_keys_control = null
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


func _process(_delta):
	pass


func _connect_with_coin_buttons():
	_coin_side_control_scene.heads_button.pressed.connect(
		_on_coin_player_picked.bind(GlobalEnums.COIN.HEADS)
	)
	_coin_side_control_scene.tails_button.pressed.connect(
		_on_coin_player_picked.bind(GlobalEnums.COIN.TAILS)
	)


func _show_arrow_keys():
	var arrow_keys_control = load(
		"res://scenes/coin_flip/coin/arrow_keys_control/arrow_keys_control.tscn"
	)
	_arrow_keys_control = arrow_keys_control.instantiate()
	get_tree().root.add_child(_arrow_keys_control)


func _get_coin_result(player_coin_name):
	for item in item_list:
		if str(item.name) == player_coin_name:
			item.pick_chance = GlobalLevelState.player_win_rate
		else:
			item.pick_chance = 1 - GlobalLevelState.player_win_rate

	var result_coin_name = pick_random_item()
	var is_successful_throw = result_coin_name == player_coin_name

	_on_coin_random_picker_picked(result_coin_name, is_successful_throw)


# Show faceless coin before flipping animation
func _reset_animation():
	_tails_animation.hide()
	_heads_animation.set_frame(0)
	_heads_animation.show()


func _deferred_add_coin_control(node):
	get_tree().root.add_child(node)
	_connect_with_coin_buttons()


# TODO: Maybe start the flipping animation but stop midway
# 	so the coin is "midair" during countdown
func _on_coin_player_picked(_player_coin_name):
	_reset_animation()
	_coin_side_control_scene.queue_free()
	_show_arrow_keys()


func _on_coin_random_picker_picked(result_coin_name, is_successful_throw):
	# TODO: Revise
	_heads_animation.animation_finished.connect(
		_on_coin_animation_finished.bind(is_successful_throw)
	)
	_tails_animation.animation_finished.connect(
		_on_coin_animation_finished.bind(is_successful_throw)
	)

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


func _on_coin_animation_finished(is_successful_throw):
	if is_successful_throw:
		GlobalCoinEvents.coin_flip_succeeded.emit()
	else:
		GlobalCoinEvents.coin_flip_failed.emit()
