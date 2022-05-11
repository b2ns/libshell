#!/usr/bin/env bash
load test_helper.sh
load ../lib/Color.sh

Color_test() { #@test
  run Color "foo"
  assert_output "foo"

  run Color "foo" "magenta"
  assert_output "\e[35mfoo\e[39m"

  run Color "foo" "blue" "bold"
  assert_output "\e[34;1mfoo\e[39;22m"

  run Color "foo" "rgb(50,150,50)"
  assert_output "\e[38;2;50;150;50mfoo\e[39m"

  run Color "foo" "#00ff00"
  assert_output "\e[38;2;0;255;0mfoo\e[39m"

  run Color "foo" "#0f0"
  assert_output "\e[38;2;0;255;0mfoo\e[39m"

  nestColor() {
    local str1=""
    local str2=""
    str1="$(Color "middle" "green")"
    str2="$(Color "head $str1 tail" "redBright" "underline")"
    echo "$str2"
  }
  run nestColor
  assert_output "\e[91;4mhead \e[32mmiddle\e[39m\e[91;4m tail\e[39;24m"
}

Color_print() { #@test
  local output=""
  run Color_print "foo"
  assert_output "foo"

  run Color "foo" "blueBright" "strikethrough"
  output="$(echo -e "\e[44;9mfoo\e[39;29m")"
  assert_output "$output"
}
