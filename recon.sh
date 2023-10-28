#!/bin/bash

echo "subdomain enumeration ..."
subfinder -dL scope.txt| anew subdomains.txt
assetfinder -subs-only paytm.in  | anew subdomains.txt
assetfinder -subs-only paytm.com  | anew subdomains.txt
assetfinder -subs-only mypaytm.com  | anew subdomains.txt
sublist3r -d paytm.in | anew subdomains.txt
sublist3r -d paytm.com | anew subdomains.txt
sublist3r -d mypaytm.com | anew subdomains.txt
crt paytm.in | anew subdomains.txt
crt paytm.com| anew subdomains.txt
crt mypaytm.com | anew subdomains.txt

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

#echo "HTTPX on resolved.txt ..."
#cat resolved.txt | httpx -sc -title  -td 

echo "IP Address Enumeration ..."
cat resolved.txt | xargs -I {} -n 1 dig +short {} | xargs -n 1 -I {} whois -h whois.cymru.com {} | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" | anew IPs.txt
cat resolved.txt | dnsx -silent -a -resp-only | anew IPs.txt

echo "Running Port Scanning"
sudo nmap -iL IPs.txt  -p0-65535 -vv -oN nmap-fullscan-ip.txt
sudo nmap -iL resolved.txt  -p0-65535 -vv -oN nmap-fullscan-subs.txt

