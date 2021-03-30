extends HBoxContainer

var player setget set_player
var kills: int = 0
var deaths: int = 0
var network_id

func set_player(_player):
	$Nickname.text = _player.nickname
	$Kills.text = str(kills)
	$Deaths.text = str(deaths)
	network_id = _player.name

