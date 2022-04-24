package main

/*
Task
define integer variables a and b, read values a and b as command-line arguments and print calculated expressions:
a + b, a - b, a * b, a / b.
USAGE
go run 3-arg-main.go 43 52
*/

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	var a, b int
	a, _ = strconv.Atoi(os.Args[1])
	b, _ = strconv.Atoi(os.Args[2])
	sum, diff, prod, div := BasicOperations(a, b)
	fmt.Printf("%d   %d\na + b = %d\na - b = %d\na * b = %d\na / b = %v\n", a, b, sum, diff, prod, div)
}

func BasicOperations(a, b int) (int, int, int, float64) {
	sum := a + b
	diff := a - b
	prod := a * b
	div := float64(a) / float64(b)
	return sum, diff, prod, div
}
