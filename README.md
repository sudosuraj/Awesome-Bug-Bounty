# Awesome Bug Bounty
This is my personal repo including bug bounty tips, tools collections, one lines I personally prefer while hunting, and so on. It is under development, so feel free to contribute.

## But, How to reocon?
Using this scrip, it automates the recon process like; subdomain enumeration, resolving subdomains, IP address gathering, port scanning on IP addressses, and as of now, I am currently working on it, I will add more functionality and approach in this script

### Running The Script
Before you run the script, make sure:
1. You've donwloaded Go-Lang, and set up env variable for go tools
2. you have basic go tools, like httpx, anew, etc...
3. The Other scripts like crt are present, (you can download them from this repo)

```chmod +x recon.sh```

```recon.sh target.com```


### What after this script is done?
Now you have:
1. resolved domains
2. IP address 
3. Scanned port reports
4. screenshots (I will add this soon)

### Besides above, what should I do? Is it all so called recon done?
Probablly not, continue approaching target,

### How?
#### Google Dorks (working)
`<find drupal>` : `inurl:”q=user/password”  site:*.gov`
