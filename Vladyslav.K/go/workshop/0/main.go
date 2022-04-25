package main

import (
	"fmt"
)

//Print a chessboard with the specified dimensions of height and width, according to the example height - 4 and wigth 6:

func main() {
	var height, width int
	var builder string
	fmt.Print("Enter height: ")
	fmt.Scan(&height)
	fmt.Print("Enter width: ")
	fmt.Scan(&width)
	fmt.Print("Enter symbol: ")
	fmt.Scan(&builder)
	fmt.Println(ChessBoard(height, width, builder))
}

func ChessBoard(height, width int, symbol string) string {
	var chessBoard string
	for i := 0; i < height; i++ {
		for j := 0; j < 2*width; j++ {
			if (i+j)%2 == 0 {
				chessBoard += symbol
			} else {
				chessBoard += " "
			}
		}
		chessBoard += "\n"
	}
	return chessBoard
}
