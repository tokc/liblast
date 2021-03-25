extends Control

signal character_selected()

onready var character_select = get_parent().get_parent().get_parent().get_parent()

func set_character(packed_character):
	var character = packed_character.instance()
	character.show_healthbar = false
	
	$Viewport.add_child(character)
	if $CharacterDisplay.connect("pressed", self, "select_character") != OK:
		print("Error connecting signal.")

func select_character():
	emit_signal("character_selected")

func _process(_delta):
	$Viewport.size = rect_size
