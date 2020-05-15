#!/bin/bash
i=VERSION
val=`cat VERSION`
dotCount=`grep '\.' -o $i | wc -l`
# if there is no version tag yet, let's start at 0.0.0
if [ -z "$val" ]; then
   echo "No existing version, starting at 0.0.0"
   echo "0.0.0" > VERSION
   exit 1
fi
if [ $dotCount -eq 0 ]
then
    val=`expr $val + 1`
else
    val=`echo $val | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}'`
fi
echo $val > VERSION
