extends Control

var target_position: Vector2
var smoothing_factor: float = .9

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Cacher le curseur de la souris du système
	$".".show()  # Afficher le nœud représentant votre curseur personnalisé
	$Cross_Passive.show()
	target_position = $".".global_position

func _input(event):
	if event is InputEventMouseMotion:
		target_position = event.position
		#print("Target position: ", target_position)

func _process(_delta):
	#print("Current position: ", $".".global_position, " Target position: ", target_position)
	$".".global_position = $".".global_position.lerp(target_position, smoothing_factor)
