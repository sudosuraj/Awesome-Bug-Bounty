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
