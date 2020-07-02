#!/usr/bin/env bash

echo ""
echo "size of swapfile in gigabytes"
echo "default swapfile 1G"
echo "Enter Swap Size : "
read -r SIZE

# does the swap file already exist?
grep -q "swapfile" /etc/fstab

# if not then create it
if [[ $? -ne 0 ]]; then
   echo "swapfile not found. Adding swapfile."
   if [[ -z $SIZE ]]; then
      echo "swap size empty, add 1G as default swapfile"
      sudo fallocate -l 1G /swapfile
   else
      echo "add ${SIZE}G as swapfile"
      sudo fallocate -l ${SIZE}G /swapfile
   fi
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   sudo cp /etc/fstab /etc/fstab.bak
   echo "/swapfile none swap sw 0 0" >> /etc/fstab

   echo "tuning swap"
   sudo sysctl vm.swappiness=30
   echo "vm.swappiness=30" >> /etc/sysctl.conf
   sudo sysctl vm.vfs_cache_pressure=50
   echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
else
   echo "swapfile found. No changes made."
fi

# output results to terminal
cat /proc/swaps
cat /proc/meminfo | grep Swap
