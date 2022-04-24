package main

/*
read 3 float numbers as command-line arguments and if they all belong to the range [-5,5], print OK, otherwise print Wrong
USAGE
go run main.go 2.5 3.5 -1.5
*/
import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	var a, b, c float64
	if len(os.Args) != 4 {
		fmt.Println("USAGE: go run main.go 2.5 3.5 -1.5")
		return
	}
	for i, v := range os.Args {
		if i == 0 {
			continue
		}
		f, err := strconv.ParseFloat(v, 64)
		if err != nil {
			fmt.Println("Wrong number:", v)
			return
		}
		if i == 1 {
			a = f
		}
		if i == 2 {
			b = f
		}
		if i == 3 {
			c = f
		}
	}
	fmt.Printf("%v\n", CheckRangeFive(a, b, c))
}

func CheckRangeFive(a, b, c float64) string {
	if a >= -5 && a <= 5 && b >= -5 && b <= 5 && c >= -5 && c <= 5 {
		return string("OK")
	}
	return string("Wrong")
}
