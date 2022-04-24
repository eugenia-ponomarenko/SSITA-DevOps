package main

/*
Implement function getMinMax which takes array as an argument and print max and min of its elements
USAGE:
go run 8-arg-main.go 1 2 3 4 5 6 7 8 9 10
*/
import (
	"fmt"
	"os"
	"strconv"
)

func GetMinMax(a []string) (int, int) {
	max, _ := strconv.Atoi(a[0])
	min := max
	for _, v := range a {
		v, _ := strconv.Atoi(v)
		if v > max {
			max = v
		}
		if v < min {
			min = v
		}
	}
	return min, max
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Provide at least one argument")
		return
	}
	for i, v := range os.Args {
		if i == 0 {
			continue
		}
		_, err := strconv.Atoi(v)
		if err != nil {
			fmt.Println("Wrong number:", v)
			return
		}
	}
	args := os.Args[1:]
	a1, a2 := GetMinMax(args)
	fmt.Printf("min: %d\nmax: %d\n", a1, a2)
}
