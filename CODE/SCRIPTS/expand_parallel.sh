#!/bin/bash
## THIS ONE WORKS FOR NYTIMES REDIRECTS!
# this makes every url in the file be fetched in parallel.
# thus, you will have as many processes as lines in the file-- be cautious.
# benchmark: 25 links in 2.830 seconds (9 links/sec)
# 100 links in 13.262 seconds (7.7 links/sec)
file="test.csv"

while read line
do 
  ##outfile=$(echo $line | awk 'BEGIN { FS = "/" } ; {print $NF}')
  # expandurl() { curl -sIL $1 | grep ^Location; }
  echo $line
  curl -sIL $line | grep ^Location | tail -n1 &
  #expandurl -o "$outfile.html" "$line"
done  < "$file" 
wait
