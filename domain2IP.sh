#!/bin/bash
OR='\e[38;5;202m'
GR='\e[32m'
NL='\e[0m'
WH='\e[97m'
BL='\e[34m'

echo -e "
${OR} ${NL}
${OR}                 _                                 _ ${NL}
${OR}                | |                               (_)${NL}
${OR} ___  _   _   __| |  ___   ___  _   _  _ __  __ _  _ ${NL}
${WH}/ __|| | | | / _  | / _ \ / __|| | | ||  |__|/ _ || |${NL}
${WH}\__ \| |_| || (_| || (_) |\__ \| |_| || |  | (_| || |${NL}
${GR}|___/ \__ _| \__ _| \___/ |___/ \__ _||_|   \__ _|| |${NL}
${GR}                                                 _/ |${NL}
${GR}                                                |__/ ${NL}
"
echo -e "This script is made by ${GR} [] sudosuraj${NL}"
echo ""
echo "[+] Domain2IP "
cat resolved.txt | xargs -I {} -n 1 dig +short {} | xargs -n 1 -I {} whois -h whois.cymru.com {} | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" | anew IPs.txt
cat resolved.txt | dnsx -silent -a -resp-only | anew IPs.txt
