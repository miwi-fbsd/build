  for nic in `ifconfig -l`
  do
    #Ignore loopback devices
    echo ${nic} | grep -qE "lo[0-9]"
    if [ 0 -eq $? ] ; then continue; fi
    #See if this device is already configured
    sysrc -ci "ifconfig_${nic}"
    if [ $? -ne 0 ] ; then
      # New ethernet device
      sysrc "ifconfig_${nic}=DHCP"
      sysrc "ifconfig_${nic}_ipv6=inet6 accept_rtadv"
    fi
  done
}
