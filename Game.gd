extends Spatial

export var is_server = true

export var SERVER_PORT = 9999 setget , get_port
export(String, "172.28.162.191", "172.28.166.24", "127.0.0.1")  var SERVER_IP = "172.28.162.191" setget , get_ip
export var MAX_PLAYERS = 10
export (String, "MENU", "PLAYING") var GAME_MODE = "MENU"

var player_scene = preload("res://Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuContainer/MainMenu/Destination/IPAdress.set_text(SERVER_IP)
	$MenuContainer/MainMenu/Destination/Port.set_text(str(SERVER_PORT))

func _input(event):
	if event.is_action_pressed("ToggleMenu"):
		if GAME_MODE == "PLAYING":
			open_menu()
		else:
			close_menu()

func open_menu():
	GAME_MODE = "MENU"
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$MenuContainer.show()

func close_menu():
	GAME_MODE = "PLAYING"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$MenuContainer.hide()

func open_quick_join_menu():
	$MenuContainer/MainMenu.hide()
	$MenuContainer/QuickJoinMenu.show()

func close_quick_join_menu():
	$MenuContainer/MainMenu.show()
	$MenuContainer/QuickJoinMenu.hide()

func join_home():
	SERVER_IP = "127.0.0.1"
	initialize_client()

func join_unfa():
	SERVER_IP = "172.25.162.191"
	initialize_client()

func join_jan():
	SERVER_IP = "172.25.166.24"
	initialize_client()

func debug_connection_status():
	if (get_tree().network_peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTING):
		print("We are trying to connect")

func get_ip():
	return SERVER_IP

func get_port():
	return SERVER_PORT

func initialize_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().connect("network_peer_connected", self, "on_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "on_peer_disconnected")
	get_tree().network_peer = peer
	close_menu()
	add_player(1, false)

func initialize_client():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().connect("connected_to_server", self, "on_connection_established")
	get_tree().connect("connection_failed", self, "on_connection_failed")
	get_tree().network_peer = peer
	close_menu()

func quit():
	get_tree().quit()

func get_player_names():
	var players =  $Players.get_children()
	
	var player_names = []
	for player in players:
		player_names.append(player.name)
	
	return player_names

sync func check_players(player_names):
	for player_name in player_names:
		if not $Players.has_node(player_name):
			var player = player_scene.instance()
			
			player.name = player_name
			$Players.add_child(player)
			player.translation += Vector3(0.0, 3.0, 0.0)
			
			if player_name == str(get_tree().get_network_unique_id()):
				player.camera.current = true
				player.set_network_master(get_tree().get_network_unique_id())
				print(get_tree().get_network_unique_id())

func add_player(id, check=true):
	var player = player_scene.instance()
	
	player.name = str(id)
	$Players.add_child(player)
	player.set_network_master(id)
	player.translation += Vector3(0.0, 3.0, 0.0)
	
	var player_names = get_player_names()
	
	if check:
		rpc("check_players", player_names)

sync func remove_player(id):
	for player in $Players.get_children():
		if player.name == str(id):
			$Players.remove_child(player)

func on_peer_connected(id):
	print("Peer connected with id ", id)
	
	add_player(id)

func on_peer_disconnected(id):
	print("Peer disconnected with id ", id)
	
	rpc("remove_player", id)

func on_connection_established():
	print("Connection has been established")

func on_connection_failed():
	print("Connection has failed")
