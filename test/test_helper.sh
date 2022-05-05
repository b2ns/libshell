#!/usr/bin/env bash

function load_lib() {
  load '../node_modules/bats-support/load'
  load '../node_modules/bats-assert/load'
  load '../node_modules/bats-file/load'
  IMPORT_ALL_LIBS=0 load '../libshell.sh'
}

load_lib
