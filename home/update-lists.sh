#!/bin/bash
echo -----------------------------------------
echo starting update
date
echo -----------------------------------------
wget https://www.internic.net/domain/named.root -qO- | sudo tee /var/lib/unbound/root.hints
sudo sqlite3 /etc/pihole/gravity.db "DELETE FROM adlist"
sudo wget -qO - https://v.firebog.net/hosts/lists.php?type=tick |xargs -I {} sudo sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (Address) VALUES ('{}');"
sudo sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (Address) VALUES ('https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts');"
sudo sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (Address) VALUES ('https://small.oisd.nl');"
sudo sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (Address) VALUES ('https://raw.githubusercontent.com/jbtranalytics/myblacklist/main/myblacklist');"
pihole -g
echo -----------------------------------------
echo finished update
date
echo -----------------------------------------

