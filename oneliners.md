##  find IP address of single domain
`dig +short target.com | xargs -n 1 -I {} whois -h whois.cymru.com {} | tee IPs.txt`

##  find IP address of multilpe domains
`cat domains.txt  | xargs -I {} -n 1 dig +short {} | xargs -n 1 -I {} whois -h whois.cymru.com {} | tee IPs.txt` 

## Using censys to collect IP
`censys search hackerone.com | grep "ip" | egrep -v "description" | cut -d ":" -f2 | tr -d \"\, | tee IPs.txt`
