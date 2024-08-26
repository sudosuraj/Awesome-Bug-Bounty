#!/bin/bash

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/anew@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/d3mondev/puredns/v2@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
