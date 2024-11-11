class_name Modifier
extends RandomItem

@export_enum("ITEM", "PERK") var type: String
## Conditions for modifier appearance.
@export_enum("ANYTIME", "NEXT_LEVEL_LAST", "BLURRY_VISION") var appear_condition: String
## Buying price for modifier.
@export var price: int
## Modifier description. Each element is a new line.
@export var description: PackedStringArray

## Effects activating on the current trial and affects on the current trial only.
@export var trial_effects: ModifierEffects
## Effects activating on the next trial and affects the next trial only.
@export var next_trial_effects: ModifierEffects
## Effects activating on the current trial and lasts multiple trials.
@export var multi_trial_effects: ModifierEffects

@export_category("Images for input states")
## Displayed as button texture on normal mode
@export_file(".png", ".jpg", ".jpeg", ".svg") var normal
## Displayed as button texture on any other action
@export_file(".png", ".jpg", ".jpeg", ".svg") var active

