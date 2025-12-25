#!/bin/sh
xsetroot -name "Loading..."

get_active_wireless_interface() {
    # Get all wireless interfaces
    wireless_interfaces=$(find /sys/class/net -type l -name "w*" -exec basename {} \; | sort)
    
    # Check each wireless interface for connection status
    for interface in $wireless_interfaces; do
        # Check if it's a wireless interface and has carrier (connected)
        if [ -d "/sys/class/net/$interface/wireless" ] && [ "$(cat /sys/class/net/$interface/carrier 2>/dev/null)" = "1" ]; then
            echo "$interface"
            return 0
        fi
    done
    
    # Fallback: check which wireless interface is up and has an IP
    for interface in $wireless_interfaces; do
        if [ -d "/sys/class/net/$interface" ] && ip addr show "$interface" 2>/dev/null | grep -q "inet "; then
            echo "$interface"
            return 0
        fi
    done
    
    # Final fallback: first wireless interface that exists
    for interface in $wireless_interfaces; do
        if [ -d "/sys/class/net/$interface" ]; then
            echo "$interface"
            return 0
        fi
    done
    
    echo ""
}

# Cache the interface to avoid frequent changes
cached_interface=""
cache_time=0
CACHE_DURATION=5  # seconds

while true; do
    DATE=$(date +"%a %b %d %H:%M")
    POW=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "0")
    RAM=$(free -h --kilo | awk '/^Mem:/ {print $3 "/" $2}')
    CPU=$[100-$(vmstat 1 2| tail -1 | awk '{print $15}')]
    
    if [ "$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)" = "Discharging" ]; then
        STATUS=""
    else
        STATUS="+"
    fi
    
    # Get current time for cache checking
    current_time=$(date +%s)
    
    # Refresh interface if cache is expired or interface is not working
    if [ $current_time -ge $cache_time ] || [ ! -d "/sys/class/net/$cached_interface" ]; then
        new_interface=$(get_active_wireless_interface)
        
        # Only update if we found a valid interface
        if [ -n "$new_interface" ] && [ -d "/sys/class/net/$new_interface" ]; then
            cached_interface="$new_interface"
            cache_time=$((current_time + CACHE_DURATION))
        fi
    fi
    
    interface="$cached_interface"
    
    if [ -n "$interface" ] && [ -d "/sys/class/net/$interface" ]; then
        DOWN_bytes_prev=$(cat /sys/class/net/$interface/statistics/tx_bytes 2>/dev/null || echo 0)
        UP_bytes_prev=$(cat /sys/class/net/$interface/statistics/rx_bytes 2>/dev/null || echo 0)
        sleep 1
        DOWN_bytes_now=$(cat /sys/class/net/$interface/statistics/tx_bytes 2>/dev/null || echo 0)
        UP_bytes_now=$(cat /sys/class/net/$interface/statistics/rx_bytes 2>/dev/null || echo 0)

        DOWN_bytes_diff=$((DOWN_bytes_now - DOWN_bytes_prev))
        UP_bytes_diff=$((UP_bytes_now - UP_bytes_prev))
        
        UP_kb=$(printf "%.2f" $(echo "scale=2; $DOWN_bytes_diff/1024" | bc))
        DOWN_kb=$(printf "%.2f" $(echo "scale=2; $UP_bytes_diff/1024" | bc))
    else
        DOWN_kb="0.00"
        UP_kb="0.00"
        interface="No Internet"
    fi
    
    xsetroot -name "[ ${interface}: ▼${DOWN_kb}Kb/s ▲${UP_kb}Kb/s ][ CPU:$CPU% ][ RAM:$RAM ][ POW:$STATUS$POW% ] $DATE"
    sleep 1
done&
