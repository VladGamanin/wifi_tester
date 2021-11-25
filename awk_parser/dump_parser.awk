BEGIN {#print "парсер iwconfig awk"
	   #FS = " "
	   FS="[ ]+|[:]|[=]" # -- это работает но дает первый пробел
	   }

/[A-z]*/ {for(i=1;i<=NF;i++)
			{if ($(i) == "Signal") {
				printf "signal_level='%s'\n", $(i+2) > "report.txt"
								}
			else if ($(i) == "Missed") {
				printf "Missed_beacon='%s'\n", $(i+2) > "report.txt"
				}
				
			else if ($(i) == "Swap") {
				printf "Swap_used='%s'\n", $(i+3) > "report.txt"
				}
			
			else if ($(i) == "Package") {
				printf "Package_temperature='%s' \n", $(i+4) > "report.txt"
				printf "High_temperature='%s' \n", $(i+8) > "report.txt"
				}
				
			else if ($(i) == "load") {
				printf "load average: '%s' '%s' '%s' \n", $(i+3), $(i+4), $(i+5) > "la.txt"
				}
			}
		}
END {
#print " ***** THE END *****"
}
