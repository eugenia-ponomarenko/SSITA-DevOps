package main

import "fmt"

/*
Task:
Output question "How are you?". Read the answer value from console and output: "You are (answer)"
USAGE:
go run main1.go
*/

func main() {
	var answer string
	fmt.Println("How are you?: ")
	fmt.Scanln(&answer)
	fmt.Println(YourName(answer))
}

func YourName(name string) string {
	return "You are " + name
}
