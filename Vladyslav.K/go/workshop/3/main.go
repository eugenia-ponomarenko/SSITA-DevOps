package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

/*
Implement a fibonacci function that returns a function (a closure) that returns successive fibonacci numbers (0, 1, 1, 2, 3, 5, …)
The next number is found by adding up the two numbers before it:

the 2 is found by adding the two numbers before it (1+1), the 3 is found by adding the two numbers before it (1+2), the 5 is (2+3)
*/

func FibonacciFunction() func() int {
	var a, b, c int
	return func() int {
		if c == 0 {
			c++
			return b
		} else if c == 1 {
			c++
			b = 1
			return b
		} else {
			c++
			a, b = b, a+b
			return b
		}
	}
}

func CheckInput(input string) (int, string) {
	if input == "0" {
		return 0, "You entered 0"
	}
	// if input == "1" {
	// 	return 0, "You entered 1, not so productive"
	// }
	if _, err := strconv.Atoi(input); err != nil {
		return 0, "You entered not a number"
	}
	enteredNumber, _ := strconv.Atoi(input)
	if enteredNumber < 0 {
		return 0, "You entered negative number"
	}
	if enteredNumber > 93 {
		return 0, "Better not to enter such a big number"
	}
	return enteredNumber, ""
}

func main() {
	fmt.Print("Enter max number of Fibonacci iterations (anything from 2 to 93): ")
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "reading standard input:", err)
	}
	if len(scanner.Text()) == 0 {
		fmt.Println("You didn't enter anything")
		return
	}
	enteredNumber, err := CheckInput(scanner.Text())
	if err != "" {
		fmt.Println(err)
		return
	}
	fibonacci := FibonacciFunction()
	fmt.Print("(")
	for i := 0; i < enteredNumber; i++ {
		fmt.Printf("%v, ", fibonacci())
	}
	fmt.Print("...)\n")
}
