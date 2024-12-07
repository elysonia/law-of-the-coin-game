class_name Coin
extends RandomPicker

var _player_coin_name = GlobalEnums.COIN.INDEX
var _arrow_keys_control_scene = null
var _coin_side_control_scene = null

@onready var _tails_animation = $TailsAnimatedSprite2D
@onready var _heads_animation = $HeadsAnimatedSprite2D
@onready var _coin_label = preload("res://scenes/coin_flip/coin/coin_label/coin_label.tscn")


func _ready():
	var coin_side_control = load(
		"res://scenes/coin_flip/coin/coin_side_control/coin_side_control.tscn"
	)

	_coin_side_control_scene = coin_side_control.instantiate()
	get_parent().add_child.call_deferred(_coin_side_control_scene)
	_coin_side_control_scene.get_node("HeadsButton").pressed.connect(
		_on_player_picked.bind(GlobalEnums.COIN.HEADS)
	)
	_coin_side_control_scene.get_node("TailsButton").pressed.connect(
		_on_player_picked.bind(GlobalEnums.COIN.TAILS)
	)

	_reset_animation()

	if GlobalLevelState.check_is_bgm_muted():
		return 
	
	SoundManager.play_sfx("clears_throat", 3)


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
	get_parent().add_child.call_deferred(_arrow_keys_control_scene)
	_arrow_keys_control_scene.initialize()
	_arrow_keys_control_scene.get_node("FlipDelayTimer").timeout.connect(_get_coin_result)


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

	if not GlobalLevelState.check_is_bgm_muted():
		SoundManager.play_sfx("gavel_3_times")

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


func _on_player_picked(player_coin_name):
	_player_coin_name = player_coin_name
	_coin_side_control_scene.queue_free()

	var coin_label = _coin_label.instantiate()
	coin_label.set_text("Picked " + str(player_coin_name) + "!")
	add_child(coin_label)
	await coin_label.fade_tween().finished
	coin_label.queue_free()

	_reset_animation()
	_show_arrow_keys()


func _on_animation_finished(is_successful_throw):
	var coin_label = _coin_label.instantiate()
	if is_successful_throw:
		coin_label.set_text("Success!")
		if not GlobalLevelState.check_is_last_level():
			var updates_label_text = (
				"+$" + str(GlobalLevelState.level_reward_money) + " reward money"
			)

			GlobalLevelState.set_money(
				GlobalLevelState.money + GlobalLevelState.level_reward_money, updates_label_text
			)

		add_child(coin_label)
		await coin_label.fade_tween().finished
		coin_label.queue_free()
		GlobalCoinEvents.coin_flip_succeeded.emit()
	else:
		coin_label.set_text("Failed...")
		add_child(coin_label)
		await coin_label.fade_tween().finished
		coin_label.queue_free()
		GlobalCoinEvents.coin_flip_failed.emit()
