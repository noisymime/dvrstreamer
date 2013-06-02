#!/bin/bash

# use this script for creating alarm video-files with zoneminder 1.25.0
# by nightcrawler
# edited by vraa (ubuntu friendly, zoneminder 1.24 friendly, h264 friendly, 1000+ frame friendly)

#make temp directory
mkdir -p /tmp/alarmvideos

# enumerate existing zoneminder monitors
cameraname=(`ls /security/events | grep '[a-za-z]' | tac`)
cameralist=(`ls /security/events/ | grep '^[0-9]'`)
cameranum=${#cameralist[@]}
eventsfolder=/security/events/
date=(`date +%d-%m-%y`)
date=28-05-13

#date config
year=(`date +%y`)
month=(`date +%m`)
day=(`date +%d`)
day=`expr $day - 1`
#year=12
#month=06
day=28
directorypath=/$year/$month/$day
#end date config

echo number of detected zoneminder monitors: ${#cameralist[@]} on $date

echo starting list generation on all cameras
for (( i=0; i<${cameranum}; i++ ));
   do
      echo starting list generation on zoneminder monitor: ${cameraname[$i]} at $eventsfolder${cameralist[$i]}$directorypath
      #find $eventsfolder${cameralist[$i]} -mtime -1 -name \*capture.jpg > /tmp/alarmvideos/${cameraname[$i]}.list
      #find -O3 $eventsfolder${cameralist[$i]}$directorypath -daystart -mtime 1 -name \*capture.jpg > /tmp/alarmvideos/$date-${cameraname[$i]}.list
      find -O3 $eventsfolder${cameralist[$i]}$directorypath -daystart -name \*capture.jpg > /tmp/alarmvideos/$date-${cameraname[$i]}.list
      echo finished list generation

      echo starting list sorting
      sort /tmp/alarmvideos/$date-${cameraname[$i]}.list -V -o /tmp/alarmvideos/$date-${cameraname[$i]}-sorted.list
      echo finished list sorting
   done
echo finished list generation on all cameras

#         -ovc xvid -xvidencopts bitrate=600:turbo:nochroma_me:notrellis:max_bframes=0:vhq=0:threads=4 \
#         -ovc x264 -x264encopts bitrate=700:subq=4:bframes=2:b_pyramid=normal:weight_b:threads=auto \
#         -ovc x264 -x264encopts preset=veryslow:tune=film:crf=15:frameref=15:fast_pskip=0:threads=auto \
#         -ovc lavc -lavcopts vbitrate=600:turbo:threads=4:vcodec=mpeg4:vmax_b_frames=0:vme=4:mbd=1:autoaspect:dia=1:vb_strategy=0:predia=1:last_pred=0 \

echo starting video generation on all cameras
for (( i=0; i<${cameranum}; i++ ));
   do
      echo starting video generation on zoneminder monitor: ${cameraname[$i]}

      mencoder mf://@/tmp/alarmvideos/$date-${cameraname[$i]}-sorted.list -mf w=640:h=480:fps=5:type=jpg \
         -ovc x264 -lavdopts threads=4 -x264encopts pass=1:bitrate=350:preset=ultrafast:tune=stillimage \
         -oac copy \
         -o /dev/null


      mencoder mf://@/tmp/alarmvideos/$date-${cameraname[$i]}-sorted.list -mf w=640:h=480:fps=5:type=jpg \
         -ovc x264 -lavdopts threads=4 -x264encopts pass=2:bitrate=350:preset=ultrafast:tune=stillimage \
         -oac copy \
         -o /tmp/alarmvideos/$date-${cameraname[$i]}.avi
      echo finished video generation
   done
echo finished video generation on all cameras

# create directory for year and month (if it's not existing)
mkdir -p /security/archive/`date +%y`/`date +%m`/

# find avi's with actual events-move to new dir
cd /tmp/alarmvideos
find *.avi -size +5k -exec mv {} /security/archive/`date +%y`/`date +%m` \;

# cleanup temp files
rm -rf /tmp/alarmvideos/*.list
rm -rf /tmp/alarmvideos/*.avi

# cleanup after 1 year archive
#find /yourarchivedirectory/images/videos* -mtime +365 -exec rm {} \;
