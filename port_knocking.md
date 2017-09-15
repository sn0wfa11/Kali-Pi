# Port Knocking

This will hide open ports until you need to access them. If you keep everything filtered, ie. don't add rules for services not associated with port knocking, then an nmap scan on your Kali-pi will show no open ports and little information about it...

## How to set it up
### Configure Initial IP Tables

- Allow local loop traffic:

`iptables -A INPUT -i lo -j ACCEPT`

- Allow all established connections and traffic related to established connections:

`iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT`

- Add rules to allow services not associated with the port knocking to be accepted in from outside:

```
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --match multiport --dports 12001:12056 -j ACCEPT
```

- Block everything else:

`iptables -A INPUT -j DROP`

- Install iptables-persistent

`apt-get install -y iptables-persistent`

- Start and enable service at boot
```
service netfilter-persistent start
update-rc.d netfilter-persistent enable
```

- Install knockd

`apt-get install -y knockd`

- Edit knockd.conf

`nano /etc/knockd.conf`

  - Change the port squence to what you want. Note that it can be more than three ports.
  - You can change the protocol by adding `:tcp` or `:udp` after the port numbers.
  
  - **IMPORTANT** Adjust the iptables rules by replacing the `-A` with `-I`. From append to insert. This makes sure that the rule for the port 22 goes at the top and not the bottom of the IPTABLES rules.
  
  - If you want to add a timeout so you don't have to worry about closing the port when done, make the configure look like below. the last two lines are the ones that make it auto close.
  
  ```
  [SSH]
    sequence = 1111:tcp 5656:udp 5555:tcp 6666:udp
    tcpflags = syn
    seq_timeout = 15
    start_command = /sbin/iptables -I INPUT 1 -s %IP% -p tcp --dport 22 -j ACCEPT
    cmd_timeout = 10
    stop_command = /sbin/iptables -D INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
  ```

- Implement the knockd service

`nano /etc/default/knockd`

  - Change `START_KNOCKD` to `1`
  
  `START_KNOCKD=1`
  
- Start knockd and enable at boot
```
service knockd start
update-rc.d knockd enable
```

**Note** There is a known issue with knockd not starting at boot because of NetworkManager issues. One option is to use a worker like in pyconnect to start the service if it is not running.

- Open port using knockd's built in knocker

`knock server_ip_address knock_sequence`

`knock kalipi 1111:tcp 5656:udp 5555:tcp 6666:udp`

- Open port using knocker and call ssh (for auto close settings.)

`knock server_ip_address knock_sequence && ssh root@server_ip_address`


https://www.digitalocean.com/community/tutorials/how-to-use-port-knocking-to-hide-your-ssh-daemon-from-attackers-on-ubuntu
