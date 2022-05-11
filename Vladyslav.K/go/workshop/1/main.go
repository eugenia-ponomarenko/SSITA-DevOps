package main

/*
scan array string
use strings split to split numbers and Atoi
add logic that counts the number of positive even numbers in the array and prints it.

Example of input data: 30,-1,-6,90,-6,22,52,123,2,35,6

*/
import (
	"fmt"
	"strconv"
	"strings"
)

func SplitStrings(str string) []int {
	var arr []int
	strArr := strings.Split(str, ",")
	for _, s := range strArr {
		i, _ := strconv.Atoi(s)
		arr = append(arr, i)
	}
	return arr
}

func CountPositiveEven(arr []int) (int, []int) {
	var count int
	var evenArr []int
	for _, i := range arr {
		if i > 0 && i%2 == 0 {
			count++
			evenArr = append(evenArr, i)
		}
	}
	return count, evenArr
}

func main() {
	var str string
	fmt.Print("Enter array of numbers: ")
	fmt.Scan(&str)
	count, evenArr := CountPositiveEven(SplitStrings(str))
	fmt.Printf("Count of positive even numbers: %v\nPositive even numbers: %v\n", count, evenArr)
}
