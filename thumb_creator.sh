#!/bin/bash

video="$1"
image="$2"
video="$3"

crop=$(mktemp --suffix=".mp4")
scale=$(mktemp --suffix=".mp4")

width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 $video)
height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 $video)
new_width=$(echo "scale=0; $width * 0.7 / 1" | bc)
crop_width=$(echo "($width/2)*2" | bc)
crop_nw=$(echo "($new_width/2)*2" | bc)

ffmpeg -i $video -vf "crop=$crop_width:$crop_width:0:$crop_nw" $crop -y && \
ffmpeg -i $crop -vf "scale=756:756" $scale -y && \
ffmpeg -i $scale -i $image -filter_complex "overlay=(W-w)/2:(H-h)/2" ${video}_thumb.gif
rm -f $crop $scale

