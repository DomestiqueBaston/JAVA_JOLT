extends Label


var actual_value = 0


func _process(_delta):
	if $".".visible_characters > actual_value && $"..".visible == true:
		$"../../../../Typing".play()
		actual_value += 1
	else:
		actual_value = 0
