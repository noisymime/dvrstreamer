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

	MonthAgo=(`date +%y/%m/%d -d '-31 days' `)
	echo Removing old data: $basedir$MonthAgo
	rm -rf $basedir$MonthAgo

	if [[ $cameraURL == v4l* ]]
	then
		timeout 10m gst-launch-1.0 v4l2src ! clockoverlay shaded-background="true" time-format="%d/%m/%yy %H:%M:%S" ! omxh264enc ! "video/x-h264,profile=high" ! h264parse ! queue max-size-bytes=10000000 ! matroskamux ! filesink location=$curdir$cameraName\-$time.mkv
	else
		#timeout 10m cvlc --quiet $cameraURL --sout "#transcode{acodec="mp3",ab="32",channels="1",vb=512,vcodec=mpgv2}:std{access=file,mux=ts,dst="$curdir$cameraName\-$time.mpg"}"
		timeout 10m cvlc --quiet $cameraURL --sout "#transcode{acodec="mp3",ab="32",channels="1"}:std{access=file,mux=mp4,dst="$curdir$cameraName\-$time.mp4"}"
	fi
done
