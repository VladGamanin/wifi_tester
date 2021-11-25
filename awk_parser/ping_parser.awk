# ping -c 5 192.168.1.1 | grep rtt
# получить средний пинг avg

BEGIN {#print "парсер пинг"
	   #FS="[ ]+|[//]|" 
	   FS="[ ]|[\/]"
	   }

/[A-z]*/ {
	#{for(i=1;i<=NF;i++) print $(i) "   " i}
	#echo $8 | sed 's/\.[0-9]*//'
	printf "avg_ping='%s'\n", $8 > "ping.sh"
	}

END {}
