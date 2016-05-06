expandurl() { curl -sIL $1 | grep ^Location; }
# unset -f expandurl
# unset -f expandurl2

# TIMEFORMAT=%R
# time expandurl http://t.co/H6OWI1zhzC
# Location: http://www.cnn.com/2015/07/30/politics/obama-democrats-iran-nuclear-deal/index.html
 

 xargs -n 1 expandurl < tester.txt
