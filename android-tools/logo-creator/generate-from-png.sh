#!/bin/bash
convert -depth 8 android-initlogo.png rgb:logo.r
./rgb2565 -rle < logo.r > initlogo.rle