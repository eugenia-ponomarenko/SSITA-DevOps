package main

import "testing"

func TestSplitStrings(t *testing.T) {
	str := "30,-1,-6,90,-6,22,52,123,2,35,6"
	arr := SplitStrings(str)
	if len(arr) != 11 {
		t.Errorf("Expected array length is 11, but got %v", len(arr))
	}
	if arr[0] != 30 {
		t.Errorf("Expected first element is 30, but got %v", arr[0])
	}
	if arr[10] != 6 {
		t.Errorf("Expected last element is 6, but got %v", arr[10])
	}
}

func TestCountPositiveEven(t *testing.T) {
	str := "30,-1,-6,90,-6,22,52,123,2,35,6"
	arr := SplitStrings(str)
	count, evenArr := CountPositiveEven(arr)
	if count != 6 {
		t.Errorf("Expected count of positive even numbers is 4, but got %v", count)
	}
	if len(evenArr) != 6 {
		t.Errorf("Expected array length is 4, but got %v", len(evenArr))
	}
	if evenArr[0] != 30 {
		t.Errorf("Expected first element is 30, but got %v", evenArr[0])
	}
	if evenArr[5] != 6 {
		t.Errorf("Expected last element is 6, but got %v", evenArr[5])
	}
	for _, i := range evenArr {
		if i%2 != 0 {
			t.Errorf("Expected all elements of array are even, but got %v", i)
		}
	}
	for _, i := range evenArr {
		if i < 0 {
			t.Errorf("Expected all elements of array are positive, but got %v", i)
		}
	}
}
