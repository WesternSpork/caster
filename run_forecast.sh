#!/bin/bash

# Run the save script to generate forecast.txt
bash save

# Check if forecast.txt was created
if [ ! -f forecast.txt ]; then
  echo "Error: forecast.txt not found!"
  exit 1
fi

# Use espeak to convert forecast.txt to forecast.mp3
espeak-ng -f forecast.txt -w forecast.wav

# Check if espeak was successful in creating forecast.wav
if [ ! -f forecast.wav ]; then
  echo "Error: forecast.wav not created!"
  exit 1
fi

# Convert forecast.wav to forecast.mp3 using ffmpeg
#ffmpeg -y -i start.mp3 -i forecast.wav -filter_complex "[1]adelay=500|500[delayed];[0][delayed]concat=n=2:v=0:a=1[out]" -map "[out]" forecast.mp3
#ffmpeg -i forecast.wav -y forecast.mp3
ffmpeg -i forecast.wav -filter_complex "aevalsrc=0:d=5[silence];[0:a][silence]concat=n=2:v=0:a=1[a]" -map "[a]" -y forecast.mp3





# Check if ffmpeg was successful in creating forecast.mp3
if [ ! -f forecast.mp3 ]; then
  echo "Error: forecast.mp3 not created!"
  exit 1
fi

# Play the forecast.mp3 using mpv
#mpv forecast.mp3
mpv --loop=inf forecast.mp3

# Cleanup temporary files
rm forecast.wav
