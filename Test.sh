#!/bin/bash
DIFF_OUTPUT="$(diff new.html old.html)"
comm -13 $DIFF_OUTPUT
