#!/usr/bin/env bash

gnuplot <<EOF
set terminal postscript eps size 3.5,2.62 enhanced color \
    font 'Helvetica,20' linewidth 2
set output "$2.eps"
load "$1"
EOF

