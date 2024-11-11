class_name ModifierEffects
extends Resource

@export_category("Player choice success rate")
## Fixed success rate of chosen coin side.
@export var fixed_coin_pick_chance: float
## Scale success rate depending on the level. e.g. 0.1 for 10% and 2.0 double the chance each round.
@export var coin_pick_chance_increment: float

## Specify fixed or range of cost for next trial.
@export_category("Trial cost")
## Fixed cost of the trial.
@export var fixed_trial_cost: int
@export var fixed_trial_cost_desc: String
## Additional range of cost for the trial.
@export_range(0, 10) var range_trial_cost
@export var range_trial_cost_desc: String

## Additional fun effects.
@export_category("Special Effects")
## Increase button mashing time in seconds
@export var button_mash_time_increase: int
## Disadvantages for the current, next or subsequent trials.
@export_enum(
	"NONE", "NO_ITEMS", "NO_MONEY", "NO_PERKS", "BLURRY_VISION", "LOWER_MODIFIER_EFFECTIVENESS"
)
var handicap: String
## For LOWER_MODIFIER_EFFECTIVENESS (0.0 - 1.0)
@export var decrease_modifier_effectiveness_by: float

@export_category("Effect State")
## Change to true while in use
var _is_in_effect: bool = false
## Change to true after use
var _was_in_effect: bool = false


func set_is_in_effect(value: bool):
	_is_in_effect = value


func set_was_in_effect(value: bool):
	_was_in_effect = value
