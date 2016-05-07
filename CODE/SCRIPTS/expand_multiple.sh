#!/bin/bash
file="nytimes_test.txt"

#expandurl() { curl -sIL $1 | grep ^Location; }

while read line
do 
  outfile=$(echo $line | awk 'BEGIN { FS = "/" } ; {print $NF}')
  # expandurl() { curl -sIL $1 | grep ^Location; }
  curl -sIL $line | grep ^Location 
  #expandurl -o "$outfile.html" "$line"
done < "$file"
