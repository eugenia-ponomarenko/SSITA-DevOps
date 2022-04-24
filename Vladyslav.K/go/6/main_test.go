package main

import (
	"testing"

	"github.com/google/go-cmp/cmp"
)

func TestDivideStringToLetters(t *testing.T) {
	tests := []struct {
		name string
		s    string
		want []string
	}{
		{
			name: "Test 1",
			s:    "Hello, world!",
			want: []string{"H", "e", "l", "l", "o", ","},
		},
		{
			name: "Test 2",
			s:    "Goodbye, world!",
			want: []string{"G", "o", "o", "d", "b", "y", "e", ","},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := DivideStringToLetters(tt.s); !cmp.Equal(got, tt.want) {
				t.Errorf("DivideStringToLetters() = %v, want %v", got, tt.want)
			}
		})
	}
}
