# Stores constants and enums

extends Node

# Modifier enums
enum ModifierType { ITEM = 0, PERK = 1 }
enum ModifierAppearCondition { ANYTIME = 0, LAST_TRIAL = 1, BLURRY_VISION = 2 }
enum ModifierHandicap {
	NONE = 0,
	NO_ITEMS = 1,
	NO_MONEY = 2,
	NO_PERKS = 3,
	BLURRY_VISION = 4,
	LOWER_MODIFIER_EFFECTIVENESS = 5
}

# INDEX is the neutral value for when no choices have been made
const COIN = {INDEX = "index", HEADS = "heads", TAILS = "tails"}

const ARROW_KEY_INCREMENT_RATE = 0.01
const DEFAULT_REWARD_MONEY = 10


