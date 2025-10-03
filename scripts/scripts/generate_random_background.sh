#!/bin/bash

r=$(($RANDOM % 255))
g=$(($RANDOM % 255))
b=$(($RANDOM % 255))
solid_color="rgb($r, $g, $b)"

rm -f $HOME/Images/backgrounds/backgroundDP1.png
magick -size 1920x1080 canvas:"$solid_color" $HOME/Images/backgrounds/backgroundDP1.png

rm -f $HOME/Images/backgrounds/backgroundDP2.png
magick -size 1080x1920 canvas:"$solid_color" $HOME/Images/backgrounds/backgroundDP2.png
