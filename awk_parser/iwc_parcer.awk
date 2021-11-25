BEGIN {#print "парсер iwconfig awk"
	   FS = " "
	   #FS="[ ]+|[:]|[=]" # -- это работает но дает первый пробел
	   }

/[A-z]*/ 
	#{
	#{for(i=1;i<=NF;i++) print $(i) "   " i}
	#}

	{
	if ($4 ~ /ESSID.*/ && $4 != "ESSID:off/any") {
		printf "Working_interface='%s'\n", $1 > "my_vars.sh" #-- форматированный вывод
		}
	}

END {
#print " ***** THE END *****"
}

