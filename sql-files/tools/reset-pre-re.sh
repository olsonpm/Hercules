#! /usr/bin/env sh

sudo systemctl stop char-server map-server login-server apache2

ragPass="$(cat ./server-specific/ragnarok-pass.txt)"

mysql --password="${ragPass}" -e 'drop database hercules; create database hercules;' hercules

filesToRun="main logs item_db mob_db mob_skill_db item_db2 mob_db2 mob_skill_db2"

for f in ${filesToRun}; do
  mysql --password="${ragPass}" hercules < "../${f}.sql"
done

. ./server-specific/server-creds.txt

mysql --password="${ragPass}" -e "update login set userid='${SERVER_SQL_USERNAME}', user_pass='${SERVER_SQL_PASS_MD5}' where account_id=1;" hercules

sudo systemctl start char-server map-server login-server apache2

echo "db reset !"
echo "make sure to visit the control panel's /install/reinstall to reinstall the sql schemas"
