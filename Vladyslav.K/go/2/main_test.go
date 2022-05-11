package main

import (
	"testing"
)

func TestCheckInt(t *testing.T) {
	var thisIsString = "this is a string"
	if CheckInt(thisIsString) != "Wrong" {
		t.Error("Expected: Wrong, got: ", CheckInt(thisIsString))
	} else if CheckInt("-5") != "OK" {
		t.Error("Expected: OK, got: ", CheckInt("5"))
	}
}
