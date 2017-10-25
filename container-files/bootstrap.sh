#!/bin/sh

set -u

# User params
USER_PARAMS=$@

# Internal params
RUN_CMD="snmpd -f ${USER_PARAMS}"

#######################################
# Echo/log function
# Arguments:
#   String: value to log
#######################################
log() {
  if [[ "$@" ]]; then echo "[`date +'%Y-%m-%d %T'`] $@";
  else echo; fi
}

#######################################
# Add custom config 
#######################################
echo "### Adding custom config ###" > /etc/snmp/snmpd.conf
echo "com2sec localhost 127.0.0.1       private" > /etc/snmp/snmpd.conf
echo "" > /etc/snmp/snmpd.conf
echo "group MyRWGroup	v1         localhost" > /etc/snmp/snmpd.conf
echo "group MyRWGroup	v2c        localhost" > /etc/snmp/snmpd.conf
echo "group MyRWGroup	usm        localhost" > /etc/snmp/snmpd.conf
echo "" > /etc/snmp/snmpd.conf
echo "access MyRWGroup ""      any       noauth    exact  all    all    none" > /etc/snmp/snmpd.conf
echo "" > /etc/snmp/snmpd.conf
echo "rwcommunity private localhost" > /etc/snmp/snmpd.conf
echo "### Custom config ###" > /etc/snmp/snmpd.conf

# Launch
log $RUN_CMD
$RUN_CMD

# Exit immidiately in case of any errors or when we have interactive terminal
if [[ $? != 0 ]] || test -t 0; then exit $?; fi
log
