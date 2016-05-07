#!/bin/bash
## THIS ONE WORKS FOR NYTIMES REDIRECTS!
# this makes every url in the file be fetched in parallel.
# thus, you will have as many processes as lines in the file-- be cautious.
# benchmark: 25 links in 2.830 seconds (9 links/sec)
# 100 links in 13.262 seconds (7.7 links/sec)
file="test.csv"
 

while IFS=, read id url
#while read line
do 
  #outfile=$(echo $url | awk 'BEGIN { FS = "/" } ; {print $NF}')
  ##echo $id  $url

  curl -sIL $url | grep ^Location | tail -n1 | cut -c 11- &
  #echo $id$url
  #curl $url
  #| grep ^Location  
  #echo $id $url
  #curl $url & 


done  < "$file" 
wait 