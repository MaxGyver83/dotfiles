#!/bin/bash
xinput test 12 | while read in ; do [[ $in = "key press   23" ]] && play -q -n synth 0.1 sin 880 2> /dev/null; done
