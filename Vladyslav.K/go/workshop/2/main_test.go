package main

import "testing"

func TestValidateBankCardNumber(t *testing.T) {
	str := "3224 1616 2323 9898"
	not_str := "3224 1616 2323 98981"
	if !ValidateBankCardNumber(str) {
		t.Errorf("Expected true, but got false")
	}
	if ValidateBankCardNumber(not_str) {
		t.Errorf("Expected false, but got true")
	}
}

func TestStarLastFourNumbers(t *testing.T) {
	str := "3224 1616 2323 9898"
	if StarLastFourNumbers(str) != "3224 1616 2323 ****" {
		t.Errorf("Expected 3224 1616 2323 ****, but got %v", StarLastFourNumbers(str))
	}
}
