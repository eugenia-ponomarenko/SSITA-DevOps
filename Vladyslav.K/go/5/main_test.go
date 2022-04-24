package main

import "testing"

func TestCheckRangeFive(t *testing.T) {
	type args struct {
		a float64
		b float64
		c float64
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "Test 1",
			args: args{
				a: 2.5,
				b: 3.5,
				c: -1.5,
			},
			want: "OK",
		},
		{
			name: "Test 2",
			args: args{
				a: 2.5,
				b: 6.5,
				c: -1.5,
			},
			want: "Wrong",
		},
		{
			name: "Test 3",
			args: args{
				a: 2.5,
				b: 3.5,
				c: -12.5,
			},
			want: "Wrong",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := CheckRangeFive(tt.args.a, tt.args.b, tt.args.c); got != tt.want {
				t.Errorf("checkRangeFive() = %v, want %v", got, tt.want)
			}
		})
	}
}
