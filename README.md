bind-osx
========

A local Bind DNS server build script for MAC OSX development environments

This script currently creates a default zone file for the domain nrma.iag and some A records.

Follow the pattern in /etc/named.conf and /var/named/nrma.iag.zone to add more zones.


## 1) USE HOMEBREW TO INSTALL BIND

brew install bind


## 2) CHECK YOUR CONFIG

/usr/local/sbin/named-checkconf /etc/named.conf

/usr/local/sbin/named-checkzone nrma.iag /var/named/nrma.iag.zone


## 3) RESTART AFTER ADDING NEW ZONE FILES

### Shutdown bind (if it was running)
launchctl unload /System/Library/LaunchDaemons/org.isc.named.plist


### Launch BIND and set it to start automatically on system reboot.
launchctl load -wF /System/Library/LaunchDaemons/org.isc.named.plist
