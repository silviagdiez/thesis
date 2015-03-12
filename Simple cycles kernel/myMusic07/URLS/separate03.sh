#!/bin/bash
for i in `cat selected.txt`
do 
#echo $i
j=`grep $i totalURLS.txt`
if [ "$j" = '' ]
then
	echo hola
else
	echo $j
fi
done

