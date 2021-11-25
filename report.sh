#! /bin/bash

time=$1
name="./time_dump/${time}dump"

grep 'Signal\|Missed beacon\|load average\|Package\|Swap' $name.txt | awk -f ./awk_parser/dump_parser.awk
