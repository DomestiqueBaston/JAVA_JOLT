extends OpenableObject

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Smoothie_Bottles_Collider,
	$Stuff_Colliders/Fruit_Juice_Bottles_Collider,
	$Stuff_Colliders/Milk_Bottles_Collider,
	$Stuff_Colliders/Butter_Knife_Collider,
	$Stuff_Colliders/Cream_Pots_Collider,
	$Stuff_Colliders/Yoghurts_Collider,
	$Stuff_Colliders/Sauce_Pan_Collider,
	$Stuff_Colliders/Eggs_Collider,
	$Stuff_Colliders/Green_Pepper_Collider,
	$Stuff_Colliders/Tomatoes_Collider,
	$Stuff_Colliders/Cauliflower_Collider,
	$Stuff_Colliders/Yellow_Pepper_Collider,
	$Stuff_Colliders/Fruits_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.REFRIGERATOR_RIGHT_END -
		Globals.Prop.REFRIGERATOR_RIGHT_BEGIN + 1)
	set_colliders(Globals.Prop.REFRIGERATOR_RIGHT_BEGIN, _my_colliders)

func set_object_visible(which: int, vis: bool):
	match which:
		Globals.Prop.SMOOTHIE_BOTTLES:
			$Removed_Objects/Smoothie_Bottles_Out.visible = not vis
			$Stuff_Colliders/Smoothie_Bottles_Collider/Smoothie_Bottles_Out.set_deferred("disabled", vis)
			$Stuff_Colliders/Smoothie_Bottles_Collider/Smoothie_Bottles.set_deferred("disabled", not vis)
		Globals.Prop.FRUIT_JUICE_BOTTLES:
			$Removed_Objects/Fruit_Juice_Bottles_Out.visible = not vis
		Globals.Prop.MILK_BOTTLES:
			$Removed_Objects/Milk_Bottle_Out.visible = not vis
			$Stuff_Colliders/Milk_Bottles_Collider/Milk_Bottle_Out.set_deferred("disabled", vis)
			$Stuff_Colliders/Milk_Bottles_Collider/Milk_Bottles.set_deferred("disabled", not vis)
		Globals.Prop.BUTTER_KNIFE:
			$Removed_Objects/Butter_Knife_Out.visible = not vis
		Globals.Prop.YOGHURTS:
			$Removed_Objects/Yoghurts_Out.visible = not vis
		Globals.Prop.EGGS:
			$Removed_Objects/Eggs_Out.visible = not vis
