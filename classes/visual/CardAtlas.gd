extends AtlasTexture
class_name CardAtlas

func _init():
	region.size = Global.CARD_SIZE

func at(row, collumn):
	Global.tmpv1[0] = Global.CARD_SIZE[0] * row  
	Global.tmpv1[1] = Global.CARD_SIZE[1] * collumn 
	region.position = Global.tmpv1
	return self
