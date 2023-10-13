##  find IP and ASN of single domain
`dig +short target.com| xargs -n 1 -I {} whois -h whois.cymru.com {}`

## find IP and asn of multiple domains
`cat domains.txt  | xargs -I {} -n 1 dig +short {} | xargs -n 1 -I {} whois -h whois.cymru.com {}`
