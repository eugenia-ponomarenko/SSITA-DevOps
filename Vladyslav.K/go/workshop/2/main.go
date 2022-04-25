package main

/*
Enter valid bank card number
Validate it
Print string with all strings covered except for the last 4

4539 1488 0343 6467
*/

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
)

func ValidateBankCardNumber(str string) bool {
	reg := regexp.MustCompile(`^[0-9]{4}[ -]?[0-9]{4}[ -]?[0-9]{4}[ -]?[0-9]{4}$`)
	return reg.MatchString(str)
}

func StarLastFourNumbers(str string) string {
	reg := regexp.MustCompile(`[0-9]{4}$`)
	return reg.ReplaceAllString(str, "****")
}

func main() {
	fmt.Print("Enter valid bank card number: ")
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	yourData := scanner.Text()
	if ValidateBankCardNumber(yourData) {
		fmt.Println(StarLastFourNumbers(yourData))
	} else {
		fmt.Println("Invalid bank card number")
	}
}
