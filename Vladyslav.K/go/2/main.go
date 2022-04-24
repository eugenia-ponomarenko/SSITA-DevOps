package main

/*
Task:
Read value as command-line argument and detect if this one is integer. If so, print OK, otherwise print Wrong.
USAGE
go run 2-arg-main.go 12311
or
go run 2-arg-main.go 123.11
*/

import (
	"fmt"
	"os"
)

func main() {
	args := os.Args[1:]
	if len(args) == 0 {
		fmt.Println("No arguments")
		return
	}
	fmt.Println(CheckInt(args[0]))
}
func CheckInt(input string) string {
	var isInt int
	_, err := fmt.Sscan(input, &isInt)
	if err == nil {
		return "OK"
	} else {
		return "Wrong"
	}
}
