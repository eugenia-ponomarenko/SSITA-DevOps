package main

/*
Read string without space as command-line argument (it means read symbols until first space-symbol) and print each of them on separate line
USAGE:
go run 6-arg-main.go "Hello, world!"
go run 6-arg-main.go Hello, world!
*/

import (
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Provide string as argument")
		return
	}
	s := os.Args[1]
	// PrintSepLetters(s)
	letters := DivideStringToLetters(s)
	for _, v := range letters {
		fmt.Println(v)
	}
}

func DivideStringToLetters(s string) []string {
	var letters []string
	for _, v := range s {
		if v != ' ' {
			letters = append(letters, string(v))
		} else {
			break
		}
	}
	return letters
}

// func DivideStringToLetters(s string) []string {
// 	var letters []string
// 	for _, v := range s {
// 		letters = append(letters, string(v))
// 	}
// 	return letters
// }
