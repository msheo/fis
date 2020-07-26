#!/bin/sh

files="./files.out"

username="fis-app"
password="fis"
nexusurl="http://192.168.123.110:8081/repository/maven-releases/" 

find . -name '*.*' -type f | cut -c 3- | grep "/" > $files

while read i;do
	 echo "upload $i to $nexusurl"
	 curl -v -u $username:$password --upload-file $i "$nexusurl$i"
 done <$files

