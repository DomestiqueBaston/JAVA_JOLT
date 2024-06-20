extends Control

var target_position: Vector2
var smoothing_factor: float = 0.9
var cursor_update_timer: Timer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Cacher le curseur de la souris du système
	$".".show()  # Afficher le nœud représentant votre curseur personnalisé
	$Cross_Passive.show()
	
	# Créer et configurer un Timer pour mettre à jour le curseur
	cursor_update_timer = Timer.new()
	cursor_update_timer.wait_time = 0.01  # Mettre à jour toutes les 0.01 secondes
	cursor_update_timer.one_shot = false
	add_child(cursor_update_timer)
	
	# Utiliser la nouvelle syntaxe de connexion pour Godot 4.x
	cursor_update_timer.timeout.connect(_update_cursor_position)
	cursor_update_timer.start()

	target_position = $".".global_position

func _input(event):
	if event is InputEventMouseMotion:
		target_position = event.position

func _update_cursor_position():
	#print("Current position: ", $".".global_position, " Target position: ", target_position)
	$".".global_position = $".".global_position.lerp(target_position, smoothing_factor)

