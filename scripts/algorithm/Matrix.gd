extends Node

class_name Matrix

var matrixX = 0
var matrixY = 0
var matrixData = []

func _init(matrixArray : Array):
	var matrixHeight = matrixArray.size()
	var matrixWidth = 0
	if matrixHeight > 0:
		for h in range(matrixHeight):
			matrixData.append(matrixArray[h])
			var matrixWidthTemp = matrixArray[h].size()
			var offsetToMaxWidth = max(0, matrixWidthTemp - matrixWidth)
			if matrixWidthTemp > matrixWidth:
				matrixWidth = matrixWidthTemp
				for n in range(h):
					for i in range(max(0, matrixWidth - matrixArray[n])):
						matrixData.append(0)
	
	matrixX = matrixWidth
	matrixY = matrixHeight

