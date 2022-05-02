package main

/*
read 3 integer numbers as command-line arguments and print max and min of them.
USAGE
go run 4-arg-main.go 44 55 22
*/
import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	var a, b, c int
	a, _ = strconv.Atoi(os.Args[1])
	b, _ = strconv.Atoi(os.Args[2])
	c, _ = strconv.Atoi(os.Args[3])
	max, min := Minmax(a, b, c)
	fmt.Printf("Max number is %v\nMin number is %v\n", max, min)
}

func Minmax(a int, b int, c int) (int, int) {
	max := a
	min := a
	if b > max {
		max = b
	}
	if c > max {
		max = c
	}
	if b < min {
		min = b
	}
	if c < min {
		min = c
	}
	return max, min
}
