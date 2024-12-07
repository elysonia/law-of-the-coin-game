extends Control


enum ContentsTypeEnum {ME = 0, ASSETS = 1, MUSIC = 2, SFX = 3, OTHERS = 4}


# IMPROVEMENT: Next time make a .txt file or a .json
const CONTENTS_LIST = [
	{
		type = ContentsTypeEnum.ME,
		title = "Developer",
		description = "Design, programming and art\nby",
		author = "Kryione (me)",
		links = null
	},
	{
		type = ContentsTypeEnum.ASSETS,
		title = "Coin flip animation",
		description = "Pixel Fantasy Coin Flip\nby",
		author = "Caz Wolf",
		links = [ {
			url = "https://cazwolf.itch.io/pixel-coinflip",
			label = "Itch.io"
		}]
	},
	{
		type = ContentsTypeEnum.MUSIC,
		title = "Title music",
		description = "Comedy Detective\nby",
		author = "Onoychenkomusic",
		links = [
			{
				url = "https://pixabay.com/music/bloopers-comedy-detective-127185/",
				label = "Pixabay"
			}
		]
	},
	{
		type = ContentsTypeEnum.MUSIC,
		title = "Game music",
		description = "Bass Vibes\nby",
		author = "Kevin MacLeod",
		links = [
			{
				url = "https://uppbeat.io/t/kevin-macleod/bass-vibes",
				label = "Uppbeat"
			}
		]
	},
	{
		type = ContentsTypeEnum.SFX,
		title = "In-game background sound",
		description = "Clears Throat\nby",
		author = "tumiwiththesounds (Freesound)",
		links = [
			{
				url = "https://pixabay.com/sound-effects/clears-throat-97166/",
				label = "Pixabay"
			}
		]
	},
	{
		type = ContentsTypeEnum.SFX,
		title = "In-game background sound",
		description = "Crowd Worried\nby",
		author = "sketchygio (Freesound)",
		links = [
			{
				url = "https://pixabay.com/sound-effects/crowd-worried-90368/",
				label = "Pixabay"
			}
		]
	},
	{
		type = ContentsTypeEnum.SFX,
		title = "In-game background sound",
		description = "Gavel of Justice\nby",
		author = "FableCityRadio",
		links = [
			{
				url = "https://pixabay.com/sound-effects/gavel-of-justice-124029/",
				label = "Pixabay"
			}
		]
	},
	{
		type = ContentsTypeEnum.SFX,
		title = "Button sound effect",
		description = "A strong beat\nby",
		author = "SoundDino",
		links = [
			{
				url = "https://sounddino.com/en/effects/court/",
				label = "SoundDino"
			}
		]
	},
	{
		type = ContentsTypeEnum.OTHERS,
		title = "Godot Plugin",
		description = "Sound Manager\nby",
		author = "Xecestel",
		links = [
			{
				url = "https://godotengine.org/asset-library/asset/361",
				label = "Godot AssetLib"
			}
		]
	},
]


@onready var _credits_text = $CreditsPanel/MarginContainer/CreditsText
@onready var _close_button = $CloseButton


func _ready():
	_close_button.pressed.connect(_on_close_button_pressed)

	var new_text_list = ["[center]"]
	new_text_list.append("\n\n[font_size={{25}}][color=light_steel_blue]Credits[/color][/font_size]\n\n\n")

	for content in CONTENTS_LIST:
		var content_text_list = construct_credits_content_text(content)
		new_text_list.append_array(content_text_list)
		new_text_list.append("\n\n\n\n")

	new_text_list.append("[font_size={{15}}]Made with Godot Engine[/font_size]\n\n")
	new_text_list.append("\n\n[font_size={{13}}][color=light_coral]Thanks for playing!\nHope it was enjoyable despite the shortcomings :D[/color][/font_size]\n\n")

	new_text_list.append("[/center]")

	var new_text_string = "".join(new_text_list)
	_credits_text.append_text(new_text_string)


func construct_credits_content_text(content):
	var content_text_list = []

	var title_format_text = "[font_size={{20}}][color=dark_orange]{text}[/color][/font_size]"
	var description_format_text = "\n[font_size={{15}}][color=mint_cream]{text}[/color][/font_size]"
	var author_format_text = "\n[font_size={{15}}][color=aqua]{text}[/color][/font_size]"
	var link_format_text = "\n[font_size={{13}}][color=cornsilk][url={url}]{label}[/url][/color][/font_size]"

	var title_text = title_format_text.format({
		text = content.title
	})
	var description_text = description_format_text.format({
		text = content.description
	})
	var author_text = author_format_text.format({
		text = content.author
	})


	content_text_list.append_array([title_text, description_text, author_text])

	if content.links != null:
		var link_text_array = content.links.map(
			func(link):
				return link_format_text.format({
					url = link.url,
					label = link.label
				})
		)

		content_text_list.append_array(link_text_array)

	return content_text_list



func _on_credits_text_meta_clicked(meta:Variant):
	OS.shell_open(str(meta))


func _on_close_button_pressed():
	queue_free()
