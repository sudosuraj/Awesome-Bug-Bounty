#!/bin/python
#this python script take urls and paths, and append evry url with path.
import argparse

# Create an ArgumentParser
parser = argparse.ArgumentParser(description="Combine URLs and paths")

# Add command-line arguments for URLs and paths
parser.add_argument("-uL", "--url-list", type=str, required=True, help="File containing a list of URLs")
parser.add_argument("-p", "--path-list", type=str, required=True, help="File containing a list of paths")

# Parse the command-line arguments
args = parser.parse_args()

# Read URLs from the provided file
with open(args.url_list, 'r') as url_file:
    urls = url_file.read().splitlines()

# Read paths from the provided file
with open(args.path_list, 'r') as path_file:
    paths = path_file.read().splitlines()

# Combine each URL with each path and print the result
for url in urls:
    for path in paths:
        combined_url = url + path
        print(combined_url)
