#!/bin/bash
# converts a local markdown file to html and publishes at seednode.co/docs/
output="$(echo $1 | cut -d"." -f1).html"
pandoc -f markdown -t html $1 | ssh gate ssh landing "tee /usr/share/nginx/html/docs/$output"
