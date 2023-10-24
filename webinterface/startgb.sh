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
# $9 noise reduction
# $10 volume
# $11 modulation
# $12 gb engine
# $13 use buffer
# $14 stream to icecast
# $15 noise profile
# $16 highpass
# $17 lowpass
# $18 sinc
# $19 compand

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

if [ "${13}" -gt 0 ]
then
	BUFFER="--buffer ${13}"
fi

if [ "$6" -gt 0  ]
then
	GAIN="-g $6 "
fi

if [ "$9" != "0" ]
then
	if [ "${15}" == "createnew" ]
	then
		`/usr/bin/timeout 10s /usr/local/bin/${12} -M ${11} -f $7 -l 0 -c $2 -m $1 -s $8 -r $5 $GAIN -F 0 -E deemp - | /usr/bin/sox -t raw -r $5 -b 16 -e signed-integer -c 1 - -r $5 -t wav -c 1 -p | /usr/bin/sox -p $NOISEPROFSAVEFILE`;
		sleep 1
		`/usr/bin/sox $NOISEPROFSAVEFILE -n noiseprof $NOISEPROFSAVEFILE.prof`;
		sleep 1
		FILTER="noisered $NOISEPROFSAVEFILE.prof $9"
	else
		FILTER="noisered $NOISEPROFDIR/${15} $9"
	fi
fi

if [ "${10}" -ne 0 ]
then
	if [ "$FILTER" == "" ]
	then
		FILTER="vol ${10}"
	else
		FILTER="$FILTER vol ${10}"
	fi
fi

if [ "${16}" -ne 0 ]
then
	if [ "$FILTER" == "" ]
	then
		FILTER="highpass ${16}"
	else
		FILTER="$FILTER highpass ${16}"
	fi
fi

if [ "${17}" -ne 0 ]
then
	if [ "$FILTER" == "" ]
	then
		FILTER="lowpass ${17}"
	else
		FILTER="$FILTER lowpass ${17}"
	fi
fi

if [ "${18}" != "0" ]
then
	if [ "$FILTER" == "" ]
	then
		FILTER="sinc ${18}"
	else
		FILTER="$FILTER sinc ${18}"
	fi
fi

if [ "${19}" != "0" ]
then
	if [ "$FILTER" == "" ]
	then
		FILTER="compand ${19}"
	else
		FILTER="$FILTER compand ${19}"
	fi
fi


if [ "$4" -gt 0 ]
then
	if [ "${14}" -ne 0 ]
	then
	`$TIMEOUT /usr/local/bin/${12} -M ${11} -f $7 -l 0 -c $2 -m $1 -s $8 -r $5 $GAIN -F 0 -E deemp - | /usr/bin/tee >(/usr/bin/sox $BUFFER -ts16 -r $5 -c1 -V1 - $SAVEFILE $FILTER) | /usr/bin/sox $BUFFER -t raw -r $5 -b 16 -e signed-integer -c 1 - -r $5 -t ogg -c 1 - $FILTER | ezstream -c /etc/ezstream.xml  > /dev/null 2>&1 &`;
	else
	`$TIMEOUT /usr/local/bin/${12} -M ${11} -f $7 -l 0 -c $2 -m $1 -s $8 -r $5 $GAIN -F 0 -E deemp - | /usr/bin/tee >(/usr/bin/sox $BUFFER -ts16 -r $5 -c1 -V1 - $SAVEFILE $FILTER) | /usr/bin/play $BUFFER -t raw -r $5 -b 16 -e signed-integer - $FILTER > /dev/null 2>&1 &`;
	fi
else
	if [ "${14}" -ne 0 ]
	then
		`$TIMEOUT /usr/local/bin/${12} -M ${11} -f $7 -l 0 -c $2 -m $1 -s $8 -r $5 $GAIN -F 0 -E deemp - | /usr/bin/sox $BUFFER -t raw -r $5 -b 16 -e signed-integer -c 1 - -r $5 -t ogg -c 1 - $FILTER | ezstream -c /etc/ezstream.xml > /dev/null 2>&1 &`;
	else
		`$TIMEOUT /usr/local/bin/${12} -M ${11} -f $7 -l 0 -c $2 -m $1 -s $8 -r $5 $GAIN -F 0 -E deemp - | /usr/bin/play $BUFFER -t raw -r $5 -b 16 -e signed-integer - -c 1 $FILTER > /dev/null 2>&1 &`;
	fi
fi

