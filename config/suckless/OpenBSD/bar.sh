#!bin/sh
xsetroot -name "Loading..."

while true; do
	DATE=$(date +"%a %b %d %H:%M")
	POW=$(apm -l)
	TEMP=$(sysctl hw | grep 'hw.sensors.cpu0.temp0' | awk -F '=' '{print $2}' | awk '{printf "%.0fºC\n", $1}')	
	CPUS=$(sysctl | grep 'hw.ncpuonline' | sed 's/^.*=//')
    	TOTALUSAGE=$(ps aux | awk '{print $3}' | sed '1d' | sort | paste -s -d+ - | bc)
    	USAGE=$(printf "$TOTALUSAGE / $CPUS\n" | bc -l)
    	CPU=$(printf "$USAGE" | grep "^\.[0-9]" > /dev/null && printf "0$(printf $USAGE | cut -c1-3)%%" || printf "$(printf "$USAGE" | cut -c1-4)%%\n")
    	TOTAL="$(free | awk '/^Mem:/ {print $2}')"
    	MUSED="$(top -b -n 1 | grep -o 'Real.*' | sed 's/Real: //' | sed 's/\/.*//')"
    	printf "$MUSED" | egrep "[0-9]{4}" > /dev/null && FUSED="$(printf "$MUSED" | cut -c -2 | sed 's/./.&/2')G" || FUSED=$MUSED
	DOWN=$(ifstat -i iwm0 1 1 | awk 'NR==3 {print $1}')
	UP=$(ifstat -i iwm0 1 1 | awk 'NR==3 {print $2}')

	xsetroot -name "[ ▼ $DOWN Kb/s ][ ▲ $UP Kb/s ][ RAM: $FUSED/$TOTAL ][ CPU: $CPU ][ TEMP: $TEMP ][ POW: $POW% ] $DATE "
	sleep 5
done&
