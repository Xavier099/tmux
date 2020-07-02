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
else
   echo "swapfile found"
   read -p "do you want to replace the current swap? [y/N]" PROMPT
   if [[ $PROMPT =~ [yY](es)* ]]; then
      echo "overwriting swap"
      sudo swapoff /swapfile
      if [[ -z $SIZE ]]; then
         echo "swap size empty, overwrite with 1G"
         sudo fallocate -l 1G /swapfile
      else
         echo "overwrite swap and changes to ${SIZE}G"
         sudo fallocate -l ${SIZE}G /swapfile
      fi
      sudo mkswap /swapfile
      sudo swapon /swapfile
   else
      echo "skip overwriting swap"
   fi
fi

echo ""
echo "tuning swap"
sudo sysctl vm.swappiness=30
echo "vm.swappiness=30" >> /etc/sysctl.conf
sudo sysctl vm.vfs_cache_pressure=50
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
echo ""

# output results to terminal
cat /proc/swaps
cat /proc/meminfo | grep Swap
