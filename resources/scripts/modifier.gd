class_name Modifier
extends RandomItem

@export_category("Modifier details")
## Name of the modifier
@export var display_name: String
@export var type: GlobalEnums.ModifierType
## Conditions for modifier appearance.
@export var appear_condition: GlobalEnums.ModifierAppearCondition
## Buying price for modifier.
@export var price: int
## Modifier description. Each element is a new line.
@export var description: PackedStringArray
## Order of application. Useful when some effects should override all others
## or depend on other effects.
@export var order: int = 0

@export_category("Modifier effects")
## Effects activating on the current trial and affects on the current trial only.
## If there are parameters overlapping with multi_trial_effect,
## move to multi_trial_effects as they are activated at the same time.
## Set is_disabled to true after use.
@export var trial_effects: ModifierEffects
## Effects activating on the next trial and affects the next trial only.
## Set is_disabled to true after use.
@export var next_trial_effects: ModifierEffects
## Effects activating on the current trial and lasts multiple trials.
## Set is_disabled to true after effect_stop_conditions are fulfilled.
@export var multi_trial_effects: ModifierEffects

@export_category("Images for input states")
## Displayed as button texture on normal mode
@export_file("*.png", "*.jpg", "*.jpeg", "*.svg") var normal: String
## Displayed as button texture on any other action
@export_file("*.png", "*.jpg", "*.jpeg", "*.svg") var active: String


@export_category("Modifier Manager")
@export_file("*.gd") var manager_script: String = "res://resources/scripts/modifier_manager.gd"
