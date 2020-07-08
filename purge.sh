#!/bin/bash
#Utility script for manually removing archive footage if a change to duration is required

basedir="/security/archive"
archiveDuration="30" #Days to keep video for

year=(`date +%y -d "-$archiveDuration days"`)
month=(`date +%m -d "-$archiveDuration days"`)
day=(`date +%d -d "-$archiveDuration days"`)

echo "rm -rf $basedir/$year/$month/$day"
