package main

import "testing"

func TestMinmax(t *testing.T) {
	type args struct {
		a int
		b int
		c int
	}
	tests := []struct {
		name  string
		args  args
		want  int
		want1 int
	}{
		{
			name: "Test 1",
			args: args{
				a: 44,
				b: 55,
				c: 22,
			},
			want:  55,
			want1: 22,
		},
		{
			name: "Test 2",
			args: args{
				a: 4235,
				b: 522,
				c: -7,
			},
			want:  4235,
			want1: -7,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, got1 := Minmax(tt.args.a, tt.args.b, tt.args.c)
			if got != tt.want {
				t.Errorf("Minmax() got = %v, want %v", got, tt.want)
			}
			if got1 != tt.want1 {
				t.Errorf("Minmax() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}
