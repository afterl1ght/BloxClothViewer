extends Node

func createMatrix(matrixArray : Array) -> Matrix:
	var matrix = load("res://scripts/algorithm/Matrix.gd")
	return matrix.new(matrixArray)

# Matrix multiplication
func matrixMul(matrix1: Matrix, matrix : Matrix):
	if matrix1.matrixX < matrix.matrixY:
		var resultingMatrix : Matrix = Matrix.new([[0]])
		print("Error Matrix X < Matrix Y")
		return resultingMatrix
		
	var newMatrix = []
	for i in range(matrix1.matrixY):
		newMatrix.append([])
		var dotProd = 0
		# Dot product calculation
		for n in range(matrix.matrixX):
			for m in range(matrix1.matrixX):
				dotProd += matrix1.matrixData[i][m] * matrix.matrixData[m][n]
			newMatrix[i].append(dotProd)
			dotProd = 0
	
	var resultingMatrix : Matrix = Matrix.new(newMatrix)
	return resultingMatrix
