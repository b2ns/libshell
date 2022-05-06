#!/usr/bin/env bash

function load_lib() {
  load '../node_modules/bats-support/load'
  load '../node_modules/bats-assert/load'
  load '../node_modules/bats-file/load'
  IMPORT_ALL_LIBS=0 load '../libshell'
}

load_lib

function makeFile() {
  local file="$1"
  if ! [[ -e "$file" ]]; then
    touch "$file"
  fi
}

function makeDir() {
  local dir="$1"
  if ! [[ -e "$dir" ]]; then
    mkdir "$dir"
  fi
}

function cleanFile() {
  local file="$1"
  if [[ -f "$file" ]]; then
    rm "$file"
  elif [[ -d "$file" ]]; then
    rmdir "$file"
  fi
}
