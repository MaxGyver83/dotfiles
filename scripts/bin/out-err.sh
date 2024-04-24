#!/bin/sh
error() { >&2 printf "\e[1;31mERROR:\e[0m $1\n"; }
info() { printf "INFO:  $1\n"; }

info "ok"
error "false"
