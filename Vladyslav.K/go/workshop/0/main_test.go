package main

import "testing"

func TestChessBoard(t *testing.T) {
	var tests = []struct {
		height, width int
		symbol        string
		expected      string
	}{
		{
			4,
			6,
			"*",
			"* * * * * * \n * * * * * *\n* * * * * * \n * * * * * *\n",
		},
		{
			3,
			3,
			".",
			". . . \n . . .\n. . . \n"},
		{
			5,
			5,
			"0",
			"0 0 0 0 0 \n 0 0 0 0 0\n0 0 0 0 0 \n 0 0 0 0 0\n0 0 0 0 0 \n",
		},
	}
	for _, test := range tests {
		actual := ChessBoard(test.height, test.width, test.symbol)
		if actual != test.expected {
			t.Errorf("ChessBoard(%d, %d, %s) = %s; expected %s", test.height, test.width, test.symbol, actual, test.expected)
		}
	}
}
