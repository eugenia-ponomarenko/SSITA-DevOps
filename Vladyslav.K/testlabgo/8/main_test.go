package main

import "testing"

func TestGetMinMax(t *testing.T) {
	type args struct {
		a []string
	}
	tests := []struct {
		name string
		args args
		min  int
		max  int
	}{
		{
			name: "Test 1",
			args: args{
				a: []string{"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"},
			},
			min: 1,
			max: 10,
		},
		{
			name: "Test 2",
			args: args{
				a: []string{"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"},
			},
			min: 1,
			max: 11,
		},
		{
			name: "Test 3",
			args: args{
				a: []string{"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"},
			},
			min: 1,
			max: 12,
		},
		{
			name: "Test 4",
			args: args{
				a: []string{"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"},
			},
			min: 1,
			max: 13,
		},
		{
			name: "Test 5",
			args: args{
				a: []string{"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14"},
			},
			min: 1,
			max: 14,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, got1 := GetMinMax(tt.args.a)
			if got != tt.min {
				t.Errorf("GetMinMax() got = %v, want %v", got, tt.min)
			}
			if got1 != tt.max {
				t.Errorf("GetMinMax() got1 = %v, want %v", got1, tt.max)
			}
		})
	}
}
