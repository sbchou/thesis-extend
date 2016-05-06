#!/bin/bash
#while read LINE ; do
#  NEWURL=$(curl -sIL $LINE 2>&1 | awk '/^Location/ {print $2}' | tail -n1;)
#  echo "$LINE ; $NEWURL"
#done < tester.txt



#curl -ILs -o /dev/null -w %{url_effective} 


while read LINE ; do

  NEWURL=$(curl -ILs $LINE 2>&1 -w %{url_effective} | tail -n1;)
  #NEWURL=$(curl -sIL $LINE 2>&1 | awk '/^Location/ {print $2}' | tail -n1;)
  echo "$LINE ; $NEWURL"
done < nytimes_test.txt
