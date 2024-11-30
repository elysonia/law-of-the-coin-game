class_name ModifierEffects
extends Resource

@export_category("Player choice success rate")
## Fixed success rate of chosen coin side for the effect.
## Stacks with the default level success rate.
@export var fixed_coin_pick_chance: float
## Scale success rate depending on the level. e.g. 0.1 for 10% and 2.0 double the chance each round.
## e.g. 1: Level 2 = 0.05 fixed_coin_pick_chance then
## Level 3 = 0.05 fixed_coin_pick_chance + 0.05 increment.
## e.g. 2: Level 2 = 0.05 fixed_coin_pick_chance
## Level 3 = 0.05 fixed_coin_pick_chance * 2.0 increment.
@export var coin_pick_chance_increment: float

## Specify fixed or range of cost for next trial.
@export_category("Trial cost")
## Fixed cost of the trial.
## The trial will cost this much by default.
## The lowest fixed trial cost is prioritized when
## an overlap occurs with another modifier.
@export var fixed_trial_cost: int
## Description of trial cost for in-game hints.
@export var fixed_trial_cost_desc: String
## Additional range of cost for the trial.
## The trial will cost an extra amount in the range specified.
## The highest extra trial cost is prioritized when
## an overlap occurs with another modifier.
@export_range(0, 10) var range_trial_cost
## Description of range of trial cost for in-game hints.
@export var range_trial_cost_desc: String

## Additional fun effects.
@export_category("Special Effects")
## Increase button mashing time in seconds
## The highest value takes priority when
## an overlap occurs with another modifier.
@export var button_mash_time_increase: int
## Modifier for the default win rate from mashing buttons relative to the default 0.01 increment.
## Positive value for increase, negative value for decrease.
## The smallest value takes priority in the occasion of an overlap.
## Keep value below or equal to 1.0 where 1.0 doubles the increment.
@export var button_mash_increment_rate: float
## Disadvantages for the current, next or subsequent trials.
@export var handicap: GlobalEnums.ModifierHandicap
## When the modifier is in effect, decrease effectiveness of other modifiers by this rate.
## The highest value takes priority when
## an overlap occurs with another modifier.
@export var decrease_other_modifiers_effectiveness_by: float

## Conditions to be fulfilled for effect to stop
@export_category("Multitrial effect stop condition")
## Stop modifier effect when the counter modifier is in effect
@export var counter_modifier: Modifier

@export_category("Effect State")
# Might not need these.
## Change to true while in use
var is_enabled: bool = false
## Change to true after use
var is_disabled: bool = false
