#!/bin/bash

# Args
# $1 hop mode
# $2 hop delay
# $3 timeout
# $4 Save to Wav
# $5 resample rate
# $6 gain
# $7 Frequency range
# $8 Sample rate/bandwidth
# $9 volume
# $10 modulation
# $11 gb engine
# $12 stream to icecast
# $13 noise profile

# Generate wav save filename
CURRENTDATE=`date +"%Y-%m-%d_%H:%M:%S"`
SAVEFILE="/home/pigb/recordings/$CURRENTDATE.wav"

# Noise profiles
NOISEPROFDIR="/var/www/html/gb/noiseprof"
NOISEPROFSAVEFILE="$NOISEPROFDIR/$CURRENTDATE-noiseprof.wav"

# Need this for bluetooth
#export XDG_RUNTIME_DIR="/run/user/1000"
#export DISPLAY=:0

#/usr/bin/pulseaudio --start

# Setting some variables
TIMEOUT=""
GAIN=""
FILTER=""
BUFFER=""
ICECAST=""

if [ "$3" -gt 0  ]
then
	TIMEOUT="/usr/bin/timeout $3m "
fi

if [ "$6" -gt 0  ]
then
	GAIN="-g $6 "
fi

if [ "${13}" != "none" ]
then
	FILTER="-af arnndn=m=/var/www/html/gb/noiseprof/${13},earwax"
fi

if [ "$9" -ne 0 ]
then
	if [ "$FILTER" == "" ]
	then
		FILTER="-af volume=$9dB"
	else
		FILTER="$FILTER,volume=$9dB"
	fi
fi

if [ "$4" -gt 0 ]
then
	if [ "${12}" -ne 0 ]
	then
		`$TIMEOUT /usr/local/bin/${11} -M ${10} -f $7 -l 0 -c $2 -m $1 -s $8 -r $5 $GAIN -F 0 -E deemp - | /usr/bin/ffmpeg -f s16le -channels 1 -sample_rate $5 -i pipe:0 $FILTER -ar $5 -f ogg -channels 1 - | tee >(sox -togg -r $5 -c1 -V1 - $SAVEFILE) | ezstream -c /etc/ezstream.xml > /dev/null 2>&1 &`;
	else
		`$TIMEOUT /usr/local/bin/${11} -M ${10} -f $7 -l 0 -c $2 -m $1 -s $8 -r $5 $GAIN -F 0 -E deemp - | /usr/bin/ffmpeg -f s16le -channels 1 -sample_rate $5 -i pipe:0 $FILTER -ar $5 -f s16le -channels 1 - | tee >(sox -ts16 -r $5 -c1 -V1 - $SAVEFILE) | /usr/bin/play -traw -r $5 -b 16 -e signed-integer - -c 1 > /dev/null 2>&1 &`;
	fi
else
	if [ "${12}" -ne 0 ]
	then
		`$TIMEOUT /usr/local/bin/${11} -M ${10} -f $7 -l 0 -c $2 -m $1 -s $8 -r $5 $GAIN -F 0 -E deemp - | /usr/bin/ffmpeg -f s16le -channels 1 -sample_rate $5 -i pipe:0 $FILTER -ar $5 -f ogg -channels 1 - | ezstream -c /etc/ezstream.xml > /dev/null 2>&1 &`;
	else
		`$TIMEOUT /usr/local/bin/${11} -M ${10} -f $7 -l 0 -c $2 -m $1 -s $8 -r $5 $GAIN -F 0 -E deemp - |  /usr/bin/ffmpeg -f s16le -channels 1 -sample_rate $5 -i pipe:0 $FILTER -ar $5 -f wav -channels 1 - | /usr/bin/play -t wav -r $5 -b 16 -e signed-integer - -c 1 > /dev/null 2>&1 &`;
	fi
fi

