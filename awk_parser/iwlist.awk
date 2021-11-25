BEGIN {#print "парсер iwlist awk"
	   #FS = " "
	   FS="[ ]+|[:]|[=]" 
	   }

/[A-z]*/ {for(i=1;i<=NF;i++)
			{if ($(i) == "Signal") {
				#print "Signal_level = " $(i+2)
				printf "Signal_level='%s'\n", $(i+2) > "var_iwlist.sh"
								}
			else if ($(i) == "Channel") {
				#print "Channel = " $(i+1)
				printf "Channel='%s'\n", $(i+1) > "var_iwlist.sh"
				}
				
			else if ($(i) == "ESSID") {
				#print "ESSID = " $(i+1)
				printf "ESSID='%s'\n", $(i+1) > "var_iwlist.sh"
				}
			 }	
		}

END {
	#print " ***** THE END *****"
	}

