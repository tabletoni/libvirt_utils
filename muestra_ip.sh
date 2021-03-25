 arp -n | grep $(virsh dumpxml $1  | grep "mac address" | awk -F\' '{ print $2}')
