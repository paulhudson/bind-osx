#!/bin/bash

# Last Updated: Jun 17, 2014
# camden@arrowtech.net
#
# Run as root or sudo the commands that need it as you go.

# 1) USE HOMEBREW TO INSTALL BIND

# 2) CONFIGURE BIND

# Create a custom launch key for BIND

/usr/local/sbin/rndc-confgen > /etc/rndc.conf
head -n 6 /etc/rndc.conf > /etc/rndc.key

# Set up a basic named.conf file.
# You may need to replace 9.10.0-P2 with the current version number if it is out of date.

cat > /usr/local/Cellar/bind/9.10.0-P1/etc/named.conf  <<END
//
// Include keys file
//
include "/etc/rndc.key";

// Declares control channels to be used by the rndc utility.
//
// It is recommended that 127.0.0.1 be the only address used.
// This also allows non-privileged users on the local host to manage
// your name server.

//
// Default controls
//
controls {
        inet 127.0.0.1 port 54 allow {any;}
        keys { "rndc-key"; };
};

options {
        directory "/var/named";
};

// 
// a caching only nameserver config
// 
zone "." IN {
    type hint;
    file "named.ca";
};

zone "localhost" IN {
    type master;
    file "localhost.zone";
    allow-update { none; };
};

zone "nrma.iag" IN {
    type master;
    file "nrma.iag.zone";
    allow-update { none; };
};

zone "0.0.127.in-addr.arpa" IN {
    type master;
    file "named.local";
    allow-update { none; };
};

logging {
        category default {
                _default_log;
        };

        channel _default_log  {
                file "/Library/Logs/named.log";
                severity info;
                print-time yes;
        };
};

END

# Symlink Homebrew's named.conf to the typical /etc/ location. 
ln -s /usr/local/Cellar/bind/9.10.0-P1/etc/named.conf /etc/named.conf 


# Create directory that bind expects to store zone files

mkdir /var/named

curl http://www.internic.net/domain/named.root > /var/named/named.ca


# Create zone file

cat > /var/named/nrma.iag.zone  <<END

\$TTL 300  ; 1 day
nrma.iag.          IN  SOA ns.nrma.iag. root.nrma.iag. (
                          2003040101      ; Serial
                          10800           ; Refresh after 3 hours
                          3600            ; Retry after 1 hour
                          604800          ; Expire after 1 week
                          86400 )         ; Minimum TTL of 1 day

; name servers
nrma.iag.          IN  NS  ns.nrma.iag.

; host to address mappings
ns.nrma.iag.        IN  A   192.168.137.95     
rwd.nrma.iag.      IN  A   192.168.137.95
i.nrma.iag.      IN  A   192.168.137.95
assets.nrma.iag.      IN  A   192.168.137.95

END


# 3) CREATE A LuanchDaemon FILE: 

cat > /System/Library/LaunchDaemons/org.isc.named.plist <<END
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Disabled</key>
        <false/>
        <key>EnableTransactions</key>
        <true/>
        <key>Label</key>
        <string>org.isc.named</string>
        <key>OnDemand</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
                <string>/usr/local/sbin/named</string>
                <string>-f</string>
        </array>
        <key>ServiceIPC</key>
        <false/>
</dict>
</plist>
END

chown root:wheel /System/Library/LaunchDaemons/org.isc.named.plist 
chmod 644 /System/Library/LaunchDaemons/org.isc.named.plist 

# Shutdown bind (if it was running)
launchctl unload /System/Library/LaunchDaemons/org.isc.named.plist


# Launch BIND and set it to start automatically on system reboot.
launchctl load -wF /System/Library/LaunchDaemons/org.isc.named.plist

echo "DNS zone file created for nrma.iag in /var/named/nrma.iag.zone"
