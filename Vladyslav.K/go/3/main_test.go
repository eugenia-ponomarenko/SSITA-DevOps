package main

import "testing"

func TestBasicOperations(t *testing.T) {
	type args struct {
		a int
		b int
	}
	tests := []struct {
		name       string
		args       args
		summ       int
		difference int
		prod       int
		divide     float64
	}{
		{
			name: "test1",
			args: args{
				a: 43,
				b: 52,
			},
			summ:       95,
			difference: -9,
			prod:       2236,
			divide:     0.8269230769230769,
		},
		{
			name: "test2",
			args: args{
				a: 256,
				b: 128,
			},
			summ:       384,
			difference: 128,
			prod:       32768,
			divide:     2,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, got1, got2, got3 := BasicOperations(tt.args.a, tt.args.b)
			if got != tt.summ {
				t.Errorf("BasicOperations() got = %v, wanted %v", got, tt.summ)
			}
			if got1 != tt.difference {
				t.Errorf("BasicOperations() got1 = %v, wanted %v", got1, tt.difference)
			}
			if got2 != tt.prod {
				t.Errorf("BasicOperations() got2 = %v, wanted %v", got2, tt.prod)
			}
			if got3 != tt.divide {
				t.Errorf("BasicOperations() got3 = %v, wanted %v", got3, tt.divide)
			}
		})
	}
}
