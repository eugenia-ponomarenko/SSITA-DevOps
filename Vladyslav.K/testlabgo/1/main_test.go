package main

import (
	"testing"
)

const testName = "Vasia"

func TestYourName(t *testing.T) {
	if YourName(testName) != "You are Vasia" {
		t.Error("Expected: You are Vasia, got: ", YourName(testName))
	}
}
