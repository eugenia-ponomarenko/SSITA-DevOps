package main

import (
	"testing"
)

func TestFibonacciFunction(t *testing.T) {
	tests := []struct {
		name   string
		give   int
		expect int
	}{
		{
			name:   "Test 1",
			give:   1,
			expect: 0,
		},
		{
			name:   "Test 2",
			give:   2,
			expect: 1,
		},
		{
			name:   "Test 3",
			give:   3,
			expect: 1,
		},
		{
			name:   "Test 4",
			give:   4,
			expect: 2,
		},
		{
			name:   "Test 5",
			give:   5,
			expect: 3,
		},
		{
			name:   "Test 6",
			give:   6,
			expect: 5,
		},
		{
			name:   "Test 7",
			give:   7,
			expect: 8,
		},
		{
			name:   "Test 8",
			give:   8,
			expect: 13,
		},
		{
			name:   "Test 9",
			give:   9,
			expect: 21,
		},
		{
			name:   "Test 10",
			give:   10,
			expect: 34,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := FibonacciFunction()
			// --------------------OLD STUFF---------------------------------------------------------------------------------
			// if tt.give == 1 {
			// 	if got() != tt.expect {
			// 		t.Errorf("tt.give ==1 FibonacciFunction() = %v, want %v", got(), tt.expect)
			// 	}
			// } else if tt.give == 2 {
			// 	if got() != tt.expect {
			// 		t.Errorf("tt.give == 2 FibonacciFunction() = %v, want %v", got(), tt.expect)
			// 	}
			// 	fmt.Println("Second test nice")
			// } else {
			// 	for i := 1; i < tt.give; i++ {
			// 		got()
			// 	}
			// 	if got() != tt.expect {
			// 		t.Errorf("Final seq FibonacciFunction() = %v, want %v", tt.give, tt.expect)
			// 	}
			// }
			// fmt.Printf("Final func value at the end of test iteration: %v\n", got())
			// --------------------OLD STUFF---------------------------------------------------------------------------------

			for i := 1; i < tt.give; i++ {
				got()
			}
			if got() != tt.expect {
				t.Errorf("Final seq FibonacciFunction() = %v(this is +1 iteration), want %v", got(), tt.expect)
			}

		})
	}
}

func TestCheckInput(t *testing.T) {
	tests := []struct {
		name   string
		give   string
		expect int
	}{
		{
			name:   "Test 1",
			give:   "1",
			expect: 1,
		},
		{
			name:   "Test 2",
			give:   "2",
			expect: 2,
		},
		{
			name:   "Test 3",
			give:   "3",
			expect: 3,
		},
		{
			name:   "Test 4",
			give:   "-4",
			expect: 0,
		},
		{
			name:   "Test 5",
			give:   "0",
			expect: 0,
		},
		{
			name:   "Test 6",
			give:   "s",
			expect: 0,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, _ := CheckInput(tt.give)
			if got != tt.expect {
				t.Errorf("CheckInput(%v) = %v, want %v", tt.give, got, tt.expect)
			}
		})
	}
}
