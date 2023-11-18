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
echo -e "This script is made by ${GR}sudosuraj${NL}"

echo "subdomain enumeration ..."
subfinder -dL inscope.txt -silent| anew subdomains1.txt
for i in $(cat inscope.txt)
do
	echo 'fired assetfinder on $i'
	assetfinder -subs-only $i  | anew subdomains1.txt
	echo 'fired sublist3r on $i'
	sublist3r -d $1 | anew subdomains1.txt
	echo 'fired crt on $i'
	/home/zoro/tools/crt.sh $i | anew subdomains1.txt
done
echo '2nd lever deep subdomain recon ...'
subfinder -dL subdomains1.txt -silent | anew subdomains.txt
for i in $(cat subdomains1.txt)
do
	echo 'fired assetfinder on $i'
	assetfinder -subs-only $i  | anew subdomains.txt
	echo 'fired sublist3r on $i'
	sublist3r -d $1 | anew subdomains.txt
	echo 'fired crt on $i'
	/home/zoro/tools/crt.sh $i | anew subdomains.txt
done
rm -rf subdomains1.txt
echo 'Subdomain Recon Done ;)'
echo "resolving subdomains ..."
wget https://raw.githubusercontent.com/proabiral/Fresh-Resolvers/master/resolvers.txt
echo 8.8.8.8 >> trusted.txt
echo 8.8.4.4 >> trusted.txt
massdns -r resolvers.txt -t A -o S subdomains.txt -w resolved0.txt
cat resolved0.txt | awk '{print $1}' | sed 's/\.$//' | sort -u | anew resolved.txt
rm -rf resolved0.txt
dnsx -l subdomains.txt -r resolvers.txt -a -resp -o resolved1.txt
cat resolved1.txt | anew resolved.txt
rm -rf resolved1.txt
puredns resolve subdomains.txt -r resolvers.txt --resolvers-trusted trusted.txt | anew resolved2.txt
cat resolved2.txt | anew resolved.txt 
rm -rf resolved2.txt

echo "HTTPX on resolved.txt ..."
cat resolved.txt | httpx -sc -title  -td -fr -cname

echo "IP Address Enumeration ..."
cat resolved.txt | xargs -I {} -n 1 dig +short {} | xargs -n 1 -I {} whois -h whois.cymru.com {} | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" | anew IPs.txt
cat resolved.txt | dnsx -silent -a -resp-only | anew IPs.txt

echo "Running Port Scanning"
sudo nmap -iL IPs.txt  -p0-65535 -vv -oN nmap-fullscan-ip.txt
sudo nmap -iL resolved.txt  -p0-65535 -vv -oN nmap-fullscan-subs.txt
