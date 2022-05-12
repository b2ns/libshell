#!/usr/bin/env bash

import Color

IO_error() {
  Color_print "${1:-}\n" "red" "blod" "${@:2}"
}

IO_info() {
  Color_print "${1:-}\n" "cyan" "${@:2}"
}

IO_log() {
  Color_print "${1:-}\n" "white" "${@:2}"
}

IO_success() {
  Color_print "${1:-}\n" "green" "${@:2}"
}

IO_warn() {
  Color_print "${1:-}\n" "yellow" "italic" "${@:2}"
}
