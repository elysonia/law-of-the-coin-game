extends Node2D

enum AnimationEnum {
	WALKING = 0,
	WALKING_TO_HOLE = 1,
	FALLING_TO_HOLE = 2,
	FALLEN = 3,
	MET_JUDGE = 4,
	MET_COIN = 5
}
const ANIMATION_ENUM_ORDER = [
	AnimationEnum.WALKING,
	AnimationEnum.WALKING_TO_HOLE,
	AnimationEnum.FALLING_TO_HOLE,
	AnimationEnum.FALLEN,
	AnimationEnum.MET_JUDGE,
	AnimationEnum.MET_COIN
]

const ANIMATION_DESCRIPTION = {
	AnimationEnum.WALKING: "[font_size={{15}}]You were going through life doing the best you can.[/font_size]\n\n\n\n",
	AnimationEnum.WALKING_TO_HOLE: "\t\t[font_size={{15}}]You walked into a deep hole (metaphor).[/font_size]\n\n\n\n",
	AnimationEnum.FALLING_TO_HOLE: "\t\t\t\t[font_size={{15}}][shake rate=20.0 level=5 connected=1]AAAAAAAAAAAAAA[/shake][/font_size]\n\n\n\n",
	AnimationEnum.FALLEN: "\t\t\t\t[font_size={{15}}][color=silver][i]Thump.[/i][/color] It was quite a fall.[/font_size]\n\n\n\n",
	AnimationEnum.MET_JUDGE: "\t\t[font_size={{15}}]Now you're at the mercy of the biased, two-faced Law of Coin.[/font_size]\n\n\n\n",
	AnimationEnum.MET_COIN: "\t\t[font_size={{15}}]How will you tilt the odds?[/font_size]\n\n\n\n",
}

@onready var _player_animation_sprite = $PlayerAnimationSprite
@onready var _description_label = $PanelContainer/DescriptionLabel

func _ready():
	_player_animation_sprite.animation_finished.connect(_on_animation_finished)


func _on_animation_finished():
	var animation_played = _player_animation_sprite.get_animation()
	var animation_enum = AnimationEnum[animation_played.to_upper()]
	var animation_enum_order_index = ANIMATION_ENUM_ORDER.find(animation_enum)
	var next_animation_enum_order_index = animation_enum_order_index + 1

	if next_animation_enum_order_index >= ANIMATION_ENUM_ORDER.size():
		return

	var next_animation_enum = ANIMATION_ENUM_ORDER[next_animation_enum_order_index]

	match next_animation_enum:
		AnimationEnum.WALKING:
			walking()
		AnimationEnum.WALKING_TO_HOLE:
			walking_to_hole()
		AnimationEnum.FALLING_TO_HOLE:
			falling_to_hole()
		AnimationEnum.FALLEN:
			fallen()
		AnimationEnum.MET_JUDGE:
			met_judge()
		AnimationEnum.MET_COIN:
			met_coin()


func player_animation():
	return _player_animation_sprite


func walking():
	_player_animation_sprite.stop()
	_description_label.append_text(ANIMATION_DESCRIPTION.get(AnimationEnum.WALKING))
	_player_animation_sprite.play("walking")


func walking_to_hole():
	_player_animation_sprite.stop()
	_description_label.append_text(ANIMATION_DESCRIPTION.get(AnimationEnum.WALKING_TO_HOLE))
	_player_animation_sprite.play("walking_to_hole")


func falling_to_hole():
	_player_animation_sprite.stop()
	_description_label.append_text(ANIMATION_DESCRIPTION.get(AnimationEnum.FALLING_TO_HOLE))
	_player_animation_sprite.play("falling_to_hole")


func fallen():
	_player_animation_sprite.stop()
	_description_label.append_text(ANIMATION_DESCRIPTION.get(AnimationEnum.FALLEN))
	_player_animation_sprite.play("fallen")


func met_judge():
	_player_animation_sprite.stop()
	_description_label.append_text(ANIMATION_DESCRIPTION.get(AnimationEnum.MET_JUDGE))
	_player_animation_sprite.play("met_judge")


func met_coin():
	_player_animation_sprite.stop()
	_description_label.append_text(ANIMATION_DESCRIPTION.get(AnimationEnum.MET_COIN))
	_player_animation_sprite.play("met_coin")


func stop():
	_player_animation_sprite.stop()
