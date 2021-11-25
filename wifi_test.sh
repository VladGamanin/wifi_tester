#!/bin/bash
# Author: Vladimir Hamanin vladg71@gmail.com

time=$(date +"%H-%M-%S")

# set get Working_interface
iwconfig | awk -f ./awk_parser/iwc_parcer.awk
source my_vars.sh
rm my_vars.sh

# get set vars: Channel, ESSID, Signal_level
iwlist $Working_interface scan | grep 'SSID\|Channel:\|Signal level' | awk -f ./awk_parser/iwlist.awk
source var_iwlist.sh
eSSID=$(echo $ESSID | tr -d \") # без кавычек для nmcli
eSSID1=$eSSID # особенности работы nmcli
rm var_iwlist.sh


echo $time > wifi.log
echo "Start initiflizing" >> wifi.log
echo "Channel = " $Channel >> wifi.log
echo "Signal_level = "$Signal_level >> wifi.log
echo "ESSID = "$ESSID >> wifi.log


source wifi_test.cfg

echo $multicard

if [[ $multicard = 1 ]] 
	then 
		eSSID1="${eSSID} 1"
fi

count=0
last_ping=0

while true
	do
	echo "count = " $count
	
	# get set avg_ping (средний пинг за 5 итераций)
	ping -c 5 192.168.1.1 | grep rtt | awk -f ./awk_parser/ping_parser.awk
	source ping.sh
	rm ping.sh
	int_avg_ping=`(echo $avg_ping | sed 's/\.[0-9]*//')`
	
	let curent_delta=($last_ping-$int_avg_ping)**2 #для сравнения по модулю сравниваю квадраты
	#echo "curent_delta= " $curent_delta
	#echo "delta = " $delta
	
	if [[ $curent_delta -ge $delta**2 ]]
		then
			time=$(date +"%H-%M-%S")
			
			# -------------------------------------------------------
			# проверка наличия сетей на том же канале
			
			nmcli conn down "$eSSID1" 	#особенности nmcli появляется единица
			nmcli -g SSID,SIGNAL,CHAN  device wifi list > channel.txt
			nmcli dev wifi connect $eSSID
			cross_channel=$(grep -Ec $Channel$ channel.txt )
			
			# -------------------------------------------------------
			# снимок состояния
			# инициализация переменных для анализа
			# signal_level 
			# Missed_beacon --	пропущенные маяки, 
			#					однозначно свидетельствует о потере сигнала
			# Swap_used
			# Package_temperature
			
			source time_dump.sh $time
			source report.sh $time 
			head -n 5 report.txt | sed -e s/,\'//g | sed -e s/\'//g | sed -e s/.0°C//g | sed -e s/+//g | sed -e s/-//g > clear_report.sh # хз почему в данном случае sed не работает через ;
 			rm report.txt
			source clear_report.sh
			# -------------------------------------------------------
			
			echo >> wifi.log
			echo "********************************************************" >> wifi.log
			echo $time >> wifi.log
			
			
			if [[ $cross_channel -ge 2 ]]
				then
					echo "В эфире сеть на рабочем канале" >> wifi.log
					cat channel.txt | grep -E $Channel$ >> wifi.log
			fi
			
			if [[ $signal_level -ge 70 ]]
				then
					echo "Плохой уровень сигнала" >> wifi.log
			fi
			
			if [[ $Package_temperature -ge $High_temperature ]]
				then
					echo "Высокая температура процессора" >> wifi.log
			fi
			
			
			echo "signal_level = " $signal_level >> wifi.log
			echo "Missed_beacon = " $Missed_beacon >> wifi.log
			echo "Swap_used = " $Swap_used >> wifi.log
			echo "cross_channel = " $cross_channel >> wifi.log
			echo "avg_ping = " $avg_ping >> wifi.log
			echo "Package_temperature = " $Package_temperature >> wifi.log
			cat la.txt | sed s/\'//g | sed s/,\s/\s/g >> wifi.log
			
			
			
			rm channel.txt
			rm clear_report.sh
			rm la.txt
	fi
	
	
	last_ping=$int_avg_ping
	count=$(($count+1))
	sleep 20
	done

