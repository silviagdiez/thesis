#!/bin/sh

for file in  *.lab
do
	echo $file
	cut -d ' ' -f 3 $file >  ${file/.lab/}.txt
done

