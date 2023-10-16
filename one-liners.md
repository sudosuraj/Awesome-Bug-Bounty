##  find IP and ASN of single domain
`dig +short target.com| xargs -n 1 -I {} whois -h whois.cymru.com {} | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}"`


## find IP and asn of multiple domains
`cat domains.txt  | xargs -I {} -n 1 dig +short {} | xargs -n 1 -I {} whois -h whois.cymru.com {} | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}"
`

##  0xNinja Subdomain Enumeration 
`python3 cet.py --domain target.com | sed -e 's:^ *::g' -e 's:^*\.::g' -e '/^$/d' | sed -e 's:*.::g' | sort -u | grep -o -E '[a-zA-Z0-9.-]+\.(com)'  |tee -a 2.txt`

`./crt.sh paytmlabs.com | tee -a 2.txt`
