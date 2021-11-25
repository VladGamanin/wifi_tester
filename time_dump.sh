#! /bin/bash


dump() {

time=$1
name="./time_dump/${time}dump"

echo "*** sensors" > $name.txt
sensors >> $name.txt
echo >> $name.txt

echo "*** iwconfig" >> $name.txt
echo >> $name.txt
iwconfig >> $name.txt
echo >> $name.txt

echo "*** free" >> $name.txt
echo >> $name.txt
free >> $name.txt
echo >> $name.txt

echo "*** top" >> $name.txt
echo >> $name.txt
top -b -n 1 > top.txt
head -n 15 top.txt >> $name.txt
rm top.txt
echo >> $name.txt

}

dump $1
