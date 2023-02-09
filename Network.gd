extends Node


const _PORT := 34500

var peers := []
var lobby_list := [["", "", 0, 0, 0], ["", "", 0, 0, 0]]


func _ready() -> void:
	# Called by Host and Client
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")


	var _network_peer = NetworkedMultiplayerENet.new()
	var _server_code = _network_peer.create_server(_PORT)

	print("Server Creation Code: " + str(_server_code))
	if _server_code == OK:
		get_tree().set_network_peer(_network_peer)
		peers.append(get_tree().get_network_unique_id())
	else:
		print("Server Setup Failed")
		get_tree().quit()


master func get_lobby_list() -> void:
	rpc_id(get_tree().get_rpc_sender_id(), "update_lobby_list", lobby_list)


#
# -- Network connection signals -- #
#
func _peer_connected(new_peer_id : int) -> void:
	print("New Peer Connected: ", str(new_peer_id))
	peers.append(new_peer_id)


func _peer_disconnected(dead_peer_id : int) -> void:
	print("Peer Disconnected: ", str(dead_peer_id))
	peers.erase(dead_peer_id)
	print(peers)
