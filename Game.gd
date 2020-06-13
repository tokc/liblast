extends Spatial

export var is_server = false

export var SERVER_PORT = 9999
export var SERVER_IP = "172.28.162.191"
export var MAX_PLAYERS = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	if is_server:
		initialize_server()
	else:
		initialize_client()

func initialize_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer

func initialize_client():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
