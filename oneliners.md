##  find IP address of single domain
`dig +short target.com | xargs -n 1 -I {} whois -h whois.cymru.com {}`

##  find IP address of multilpe domains
`cat domains.txt  | xargs -I {} -n 1 dig +short {} | xargs -n 1 -I {} whois -h whois.cymru.com {}` 