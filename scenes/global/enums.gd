# Stores constants and enums

extends Node

# Modifier enums
enum ModifierType { ITEM = 0, PERK = 1 }
enum ModifierAppearCondition { ANYTIME = 0, LAST_TRIAL = 1, BLURRY_VISION = 2 }
enum ModifierHandicap {
	NONE = 0,
	NO_ITEMS = 1, # Done in perks_and_items_random_picker.gd
	NO_MONEY = 2, # Item with this handicap only appears in the last round by default
	NO_PERKS = 3, # Done in perks_and_items_random_picker.gd
	BLURRY_VISION = 4,
	LOWER_MODIFIER_EFFECTIVENESS = 5
}
enum GameMode { MODIFIER_SELECTION = 0, COIN_FLIP = 1 }

# INDEX is the neutral value for when no choices have been made
const COIN = {INDEX = "index", HEADS = "heads", TAILS = "tails"}

const ARROW_KEY_INCREMENT_RATE = 0.05
const DEFAULT_REWARD_MONEY = 10
