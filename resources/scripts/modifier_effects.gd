class_name ModifierEffects
extends Resource

@export_category("Player choice success rate")
## Fixed success rate of chosen coin side.
## Replaces the default level coin pick chance.
## Stacks with coin_pick_chance_increment.
@export var fixed_coin_pick_chance: float
## Scale success rate depending on the level. e.g. 0.1 for 10% and 2.0 double the chance each round.
@export var coin_pick_chance_increment: float

## Specify fixed or range of cost for next trial.
@export_category("Trial cost")
## Fixed cost of the trial.
@export var fixed_trial_cost: int
## Description of trial cost for in-game hints.
@export var fixed_trial_cost_desc: String
## Additional range of cost for the trial.
@export_range(0, 10) var range_trial_cost
## Description of range of trial cost for in-game hints.
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
## For when the modifier counters other level modifiers.
@export var decrease_level_modifiers_effectiveness_by: float

@export_category("Effect State")
## Change to true while in use
var _is_in_use: bool = false
## Change to true after use
var _is_used: bool = false


func set_is_in_use(value: bool):
	_is_in_use = value


func set_is_used(value: bool):
	_is_used = value
