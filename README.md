bind-osx
========

A local Bind DNS server build script for MAC OSX development environments

This script currently creates a default zone file for the domain nrma.iag and some A records.

Follow the pattern in /etc/named.conf and /var/named/nrma.iag.zone to add more zones.


#### 1) Use homebrew to install Bind

Install the popular Bind DNS server with homebrew (http://brew.sh/):

- **brew install bind**


#### 2) Install and setup

Clone this repo, and run setup from terminal commands:

- **cd bind-osx**
- **sudo ./bind-setup.sh**


#### 3) Set your local IP in config

Edit the default zone file and replace every instance of 192.168.137.95 IP with your own local IP:

- **vi /var/named/nrma.iag.zone**

*(optionally)* Add any subdomains to the 'IN A' records section at the bottom of the file.


#### 3) Check your configs

Checks the Bind config

- **/usr/local/sbin/named-checkconf /etc/named.conf**

Check the nrma.iag DNS zone file config

- **/usr/local/sbin/named-checkzone nrma.iag /var/named/nrma.iag.zone**


### 4) Start using your local DNS Server

Flush your Mac's DNS cache:

- **sudo dscacheutil -flushcache**


You need to set the DNS server on any device you wish to connect to your Mac's local DNS server. Simply edit the network settings and add your Mac's local IP as your devices DNS server.




#### Restart After adding new DNS zone files

##### Shutdown bind (if it was running)
- **launchctl unload /System/Library/LaunchDaemons/org.isc.named.plist**


##### Launch BIND and set it to start automatically on system reboot.
- **launchctl load -wF /System/Library/LaunchDaemons/org.isc.named.plist**



