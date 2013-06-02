#!/bin/bash

basedir="/security/archive/"
cameraURL="127.0.0.1"
cameraName="camera"

#Check for camera address and name
if [ $# -eq 0 ]
  then
    echo "No arguments supplied-Using defaults"
  else
    cameraURL=$1
    cameraName=$2
fi


year=(`date +%y`)
month=(`date +%m`)
day=(`date +%d`)
date=$year$month$day

finish=0
trap 'finish=1' SIGINT

while (( finish != 1 ))
do
	year=(`date +%y`)
	month=(`date +%m`)
	day=(`date +%d`)
	time=(`date +%H:%M:%S`)
	echo $time
	curdir=$basedir$year/$month/$day/
	mkdir -p $curdir
	timeout 10m cvlc --quiet $cameraURL --sout "#transcode{acodec="mp3",ab="32",channels="1"}:std{access=file,mux=mp4,dst="$curdir$cameraName\-$time.mp4"}"
done
