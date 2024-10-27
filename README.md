# Awesome Bug Bounty
>_ Web Pentest Methodology by @sudosuraj

This is my personal repo including bug bounty tips, tools collections, one liners I personally prefer while hunting, and so on. It is under development, so feel free to contribute.

## Tools Installation

```@bash
#!/bin/bash

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/anew@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/d3mondev/puredns/v2@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/utkusen/socialhunter@latest
go install -v github.com/PentestPad/subzy@latest
go install github.com/003random/getJS/v2@latest
#https://github.com/0xRyuk/crtsh.git
sudo apt install python3-pip
pip3 install uro
pip3 install urless
pipx install bbot

git clone https://github.com/0xRyuk/crtsh.git /tmp/crtsh
pip3 install -r /tmp/crtsh/requirments.txt
sudo mkdir -p /opt/crtsh
sudo cp /tmp/crtsh/crtsh.py /opt/crtsh/
sudo echo 'alias crtsh="python3 /opt/crtsh/crtsh.py"'>>~/.zshrc
. ~/.zshrc

git clone https://github.com/m4ll0k/SecretFinder.git /tmp/secretfinder
pip install -r /tmp/secretfinder/requirements.txt
sudo mkdir -p /opt/secretfinder
sudo cp /tmp/secretfinder/SecretFinder.py  /opt/secretfinder/secretfinder.py
sudo echo 'alias secretfinder="python3 /opt/secretfinder/secretfinder.py"'>>~/.zshrc
. ~/.zshrc

git clone https://github.com/GerbenJavado/LinkFinder.git
cd LinkFinder
sudo mkdir -p /opt/linkfinder
sudo cp linkfinder.py /opt/linkfinder/linkfinder.py
sudo echo 'alias linkfinder="python3 /opt/linkfinder/linkfinder.py"'>>~/.zshrc
. ~/.zshrc
```

## Sub-domains 
### Enumaration :
```@bash
subfinder -dL domains.txt -all  -recursive | anew rawsubdomains.txt

cat domains.txt | while read domain; do assetfinder $domain -subs-only && anew rawsubdomains.txt; done

cat domains.txt | while read domain; do crtsh -d $domain && anew rawsubdomains.txt; done

for i in $(cat domains.txt);do bbot -t $i -p subdomain-enum; done

```

### Resolving: 
```@bash
#!/bin/bash
subfinder -dL domains.txt -all  -recursive | anew rawsubdomains.txt
cat domains.txt | while read domain; do assetfinder $domain -subs-only && anew rawsubdomains.txt; done 
cat domains.txt | while read domain; do crtsh -d $domain && anew rawsubdomains.txt; done

wget https://raw.githubusercontent.com/proabiral/Fresh-Resolvers/master/resolvers.txt
echo 8.8.8.8 >> trusted.txt
echo 8.8.4.4 >> trusted.txt
massdns -r resolvers.txt -t A -o S rawsubdomains.txt -w resolved0.txt
cat resolved0.txt | awk '{print $1}' | sed 's/\.$//' | sort -u | anew subdomains.txt
dnsx -l rawsubdomains.txt -r resolvers.txt -a -resp -o resolved1.txt
cat resolved1.txt |awk '{print $1}' | sed 's/\.$//' | sort -u | anew subdomains.txt
puredns resolve rawsubdomains.txt -r resolvers.txt --resolvers-trusted trusted.txt | anew resolved2.txt
cat resolved2.txt | awk '{print $1}' | sort -u | anew subdomains.txt

cat resolved*.txt | grep -E -o '((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | anew IPs.txt

rm -rf resolve*.txt && rm -rf trusted.txt

 cat IPs.txt | httpx-toolkit -title -ports 66,80,81,443,445,457,1080,1100,1241,1352,1433,1434,1521,1944,2301,3000,3128,3306,4000,4001,4002,4100,5000,5432,5800,5801,5802,6346,6347,7001,7002,8000,8080,8443,8888,30821 -threads 300 anew alive.txt 


 cat subdomains.txt | httpx-toolkit -title -ports 66,80,81,443,445,457,1080,1100,1241,1352,1433,1434,1521,1944,2301,3000,3128,3306,4000,4001,4002,4100,5000,5432,5800,5801,5802,6346,6347,7001,7002,8000,8080,8443,8888,30821 -threads 300 | anew alive.txt

echo Done!
```
### Subdomain Takeover
```
subzy run --targets alive.txt
```

## Find running services :

https://raw.githubusercontent.com/Bo0oM/services-names-wordlist/master/list.txt


## Broken Link Hijacking

```
socialhunter -f alive.txt
```
## Scan ports from [ports.txt](ports.txt) on IPs.txt
```@bash
sudo masscan $(cat IPs.txt)  -p0-65535 --rate 1000 --wait 3 2> /dev/null | grep -o -P '(?<=port ).*(?=/)' | anew ports.txt
```

## Ports Scanning With Naabu
```@bash
naabu -list domains.txt -c 50 -nmap-cli 'nmap -sCV' | anew naabufull.txt
naabu -list subdomains.txt -c 50 -nmap-cli 'nmap -sCV' | anew naabufull.txt
```
## Find technology
```@bash
cat urls.txt| while read urls; do webtech -u $urls; done
```

## Content Discovery
```@bash
dirsearch -l alive.txt -x 500,502,503,429 -R 5 --random-agent -t 100 -F  -w /usr/share/wordlists/seclists/Discovery/Web-Content/raft-medium-directories.txt

cat subdomains.txt | httpx -title -td -sc -fr | anew alive.txt

cat alive.txt | gau | anew allurls.txt

katana -u alive.txt -d 5 -ps -pss waybackarchive,commoncrawl,alienvault -kf -jc -fx -ef woff,css,png,svg,jpg,woff2,jpeg,gif,svg -o allurls.txt

cat alive.txt | hakrawler | anew allurls.txt

cat allurls.txt | grep -E "\.txt|\.log|\.cache|\.secret|\.db|\.backup|\.bkp|\.yml|\.json|\.gz|\.rar|\.gzip|\.zip|\.config"
```

## Parameter Discovery
```@bash
cat alive.txt | gau | grep "=" | uro | anew params.txt
for i in subdomains.txt; do paramspider -d $(i) | anew param.txt; done
```


## Find and enumerate JavaScript Files
```@bash
cat allurls.txt | grep -i -E "\.js" | egrep -v "\.json" | httpx -mc 200 | anew jsfiles.txt

while read -r url; do
  if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q 200 && \
     curl -s -I "$url" | grep -iq 'Content-Type:.*\(text/javascript\|application/javascript\)'; then
    echo "$url"
  fi
done < jsfiles.txt > livejsfiles.txt


# https://github.com/m4ll0k/SecretFinder

cat jsfiles.txt | while read url; do python3 secretfinder.py -i $url -o cli >> secrets.txt; done

nuclei -l jsfiles.txt -t /home/enma/nuclei-templates/http/exposures/ -o jsecrets.txt

cat jsfiles.txt | while read url; do linkfinder -i $url -o cli >> endpoints-js.txt; done

cat jsfiles.txt | xargs -I{} python3 /opt/linkfinder/linkfinder.py -i {} -o cli | anew endpoints-js.txt


# Download JS Files

## curl
mkdir -p js_files; while IFS= read -r url || [ -n "$url" ]; do filename=$(basename "$url"); echo "Downloading $filename JS..."; curl -sSL "$url" -o "downloaded_js_files/$filename"; done < "$1"; echo "Download complete."

## wget
sed -i 's/\r//' js.txt && for i in $(cat liveJS.txt); do wget "$i"; done
```


## GraphQL API
```@bash
grep -r -i -o -E "http[s]?://[a-zA-Z0-9./?=_-]*\b(graphql)" | anew graphql_endpoints.txt
grep -r -i "graphql\|mutation" . | anew graphql_endpoints.txt
```
### POST request introspection query:
```@bash
{"query": "query IntrospectionQuery{__schema{queryType{name}mutationType{name}subscriptionType{name}types{...FullType}directives{name description locations args{...InputValue}}}}fragment FullType on __Type{kind name description fields(includeDeprecated:true){name description args{...InputValue}type{...TypeRef}isDeprecated deprecationReason}inputFields{...InputValue}interfaces{...TypeRef}enumValues(includeDeprecated:true){name description isDeprecated deprecationReason}possibleTypes{...TypeRef}}fragment InputValue on __InputValue{name description type{...TypeRef}defaultValue}fragment TypeRef on __Type{kind name ofType{kind name ofType{kind name ofType{kind name ofType{kind name ofType{kind name ofType{kind name ofType{kind name}}}}}}}}"}
```
### GET request introspection query:
```@bash
/?query=fragment%20FullType%20on%20Type%20{+%20%20kind+%20%20name+%20%20description+%20%20fields%20{+%20%20%20%20name+%20%20%20%20description+%20%20%20%20args%20{+%20%20%20%20%20%20...InputValue+%20%20%20%20}+%20%20%20%20type%20{+%20%20%20%20%20%20...TypeRef+%20%20%20%20}+%20%20}+%20%20inputFields%20{+%20%20%20%20...InputValue+%20%20}+%20%20interfaces%20{+%20%20%20%20...TypeRef+%20%20}+%20%20enumValues%20{+%20%20%20%20name+%20%20%20%20description+%20%20}+%20%20possibleTypes%20{+%20%20%20%20...TypeRef+%20%20}+}++fragment%20InputValue%20on%20InputValue%20{+%20%20name+%20%20description+%20%20type%20{+%20%20%20%20...TypeRef+%20%20}+%20%20defaultValue+}++fragment%20TypeRef%20on%20Type%20{+%20%20kind+%20%20name+%20%20ofType%20{+%20%20%20%20kind+%20%20%20%20name+%20%20%20%20ofType%20{+%20%20%20%20%20%20kind+%20%20%20%20%20%20name+%20%20%20%20%20%20ofType%20{+%20%20%20%20%20%20%20%20kind+%20%20%20%20%20%20%20%20name+%20%20%20%20%20%20%20%20ofType%20{+%20%20%20%20%20%20%20%20%20%20kind+%20%20%20%20%20%20%20%20%20%20name+%20%20%20%20%20%20%20%20%20%20ofType%20{+%20%20%20%20%20%20%20%20%20%20%20%20kind+%20%20%20%20%20%20%20%20%20%20%20%20name+%20%20%20%20%20%20%20%20%20%20%20%20ofType%20{+%20%20%20%20%20%20%20%20%20%20%20%20%20%20kind+%20%20%20%20%20%20%20%20%20%20%20%20%20%20name+%20%20%20%20%20%20%20%20%20%20%20%20%20%20ofType%20{+%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20kind+%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20name+%20%20%20%20%20%20%20%20%20%20%20%20%20%20}+%20%20%20%20%20%20%20%20%20%20%20%20}+%20%20%20%20%20%20%20%20%20%20}+%20%20%20%20%20%20%20%20}+%20%20%20%20%20%20}+%20%20%20%20}+%20%20}+}++query%20IntrospectionQuery%20{+%20%20schema%20{+%20%20%20%20queryType%20{+%20%20%20%20%20%20name+%20%20%20%20}+%20%20%20%20mutationType%20{+%20%20%20%20%20%20name+%20%20%20%20}+%20%20%20%20types%20{+%20%20%20%20%20%20...FullType+%20%20%20%20}+%20%20%20%20directives%20{+%20%20%20%20%20%20name+%20%20%20%20%20%20description+%20%20%20%20%20%20locations+%20%20%20%20%20%20args%20{+%20%20%20%20%20%20%20%20...InputValue+%20%20%20%20%20%20}+%20%20%20%20}+%20%20}+}
```
related article: https://medium.com/@jonathanmondaut/from-developer-to-hacker-breaking-into-graphql-6083c80b4588

## SQLi one-liner
```@bash
cat subs.txt | (gau || hakrawler || katana || waybckurls) | grep "=" | anew tmp-sqli.txt && sqlmap -m tmp-sqli.txt --batch --random-agent --level 5 --risk 3 --dbs && for i in $(cat tmp-sqli.txt); do ghauri -u "$i" --level 3 --dbs --current-db --batch --confirm; done
```

>_ find which host is vuln in output folder of sqlmap/ghauri root@bb:~/.local/share/sqlmap/output:
```
	find -type f -name "log" -exec sh -c 'grep -q "Parameter" "{}" && echo "{}: SQLi"' \;
```
>_ Bypass WAF using TOR
```
	sqlmap -r request.txt --time-sec=10 --tor --tor-type=SOCKS5 --check-tor --dbs --random-agent --tamper=space2comment
```
>_ Bypass WAF using SQLmap Tamper Scripts
```
	sqlmap --list-tampers | grep "*" | awk '{print $2}' | grep ".py" | tr '\n' ','| sed 's/.py//g'
```
```
	sqlmap -u 'http://www.site.com/search.cmd?form_state=1' --level=5 --risk=3 --tamper=apostrophemask,apostrophenullencode,base64encode,between,chardoubleencode,charencode,charunicodeencode,equaltolike,greatest,ifnull2ifisnull,multiplespaces,nonrecursivereplacement,percentage,randomcase,securesphere,space2comment,space2plus,space2randomblank,unionalltounion,unmagicquotes --no-cast --no-escape --dbs --random-agent
```

##  find IP and ASN of single domain
`dig +short target.com| xargs -n 1 -I {} whois -h whois.cymru.com {} | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}"`


## find IP and asn of multiple domains
### 1
`cat domains.txt  | xargs -I {} -n 1 dig +short {} | xargs -n 1 -I {} whois -h whois.cymru.com {} | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}"
`
### 2
`cat subfinder.txt | dnsx -silent -a -resp-only | anew IPs.txt`

##  0xNinja Subdomain Enumeration 
### 1 Subdomain Enumeration of single domain
`python3 cet.py --domain target.com | sed -e 's:^ *::g' -e 's:^*\.::g' -e '/^$/d' | sed -e 's:*.::g' | sort -u | grep -o -E '\b[a-zA-Z0-9.-]*target[a-zA-Z0-9.-]*\.(com)\b' |tee -a 2.txt`

`./crt.sh paytmlabs.com | tee -a 2.txt`


### 2 Subdomain Enumeration of multiple domains (inscope-domains.txt)
`cat inscope-domains.txt | xargs -I {} -n 1 python3 cet.py --domain {} |  sed -e 's:^ *::g' -e 's:^*\.::g' -e '/^$/d' | sed -e 's:*.::g' | sort -u | grep -o -E '\b[a-zA-Z0-9.-]*target[a-zA-Z0-9.-]*\.(com)\b' |tee -a 2.txt `

`cat inscope-domains.txt | xargs -I {} -n 1 bash crt.sh | tee -a 2.txt  `

### 3 Resolving Live subdomains
Download fresh resolvers: [here](https://raw.githubusercontent.com/proabiral/Fresh-Resolvers/master/resolvers.txt)

`wget https://raw.githubusercontent.com/proabiral/Fresh-Resolvers/master/resolvers.txt`

`massdns -r resolvers.txt -t A -o S subdomains.txt -w resolved.txt`

`puredns resolve subdomains.txt -r resolvers.txt --resolvers-trusted trusted.txt | anew resolved2.txt`

`dnsx -l subdomains.txt -r resolvers.txt -a -resp -o resolved1.txt`


### 4. Find Subdomains of multiple tld
```bash
while read domain; do if host “$domain” > /dev/null; then echo $domain;fi;done<DutchGov.txt >> domains.txt
for sub in $(cat domains.txt);do subfinder -d $sub -o $sub.dutch;done
cat *.dutch > all.sub
```

### 5. FUZZ Multile Domains at once
```Bash
for i in $(cat all.sub); do echo””; echo “Subdomain of $i”;echo “”;gobuster dir -w wordlist.txt -u $i -e -o tmp ;cat tmp >> dutch.fuzz; echo “”; done
```
##  find IP address of single domain
`dig +short target.com | xargs -n 1 -I {} whois -h whois.cymru.com {} | tee IPs.txt`

##  find IP address of multilpe domains
`cat domains.txt  | xargs -I {} -n 1 dig +short {} | xargs -n 1 -I {} whois -h whois.cymru.com {} | tee IPs.txt` 

## Using censys to collect IP
`censys search hackerone.com | grep "ip" | egrep -v "description" | cut -d ":" -f2 | tr -d \"\, | tee IPs.txt`

