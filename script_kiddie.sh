#!/usr/bin/env bash

# colors in sed: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# and: https://unix.stackexchange.com/questions/45924/using-sed-to-color-the-output-from-a-command-on-solaris
esc=$(printf '\033')
yellow="${esc}[33m"
blue="${esc}[34m"
nc="${esc}[0m" # No Color

grep -v ':--' clickhouse-server-logs.txt | \
cut -d ':' -f2- | \
sed -e 's/^[0-9]*[:-]//' | \
awk 'BEGIN {print "Only unique Debug level logs for PostgreSQL"} /PostgreSQL/ && $7=="<Debug>" { printf $1" "$2":"; for(i=8;i<=NF;i++) printf " "$i; print "" }' | \
sed -e 's/: New connection/\U&/' -e "s/PostgreSQLReaplicaConsumer/${yellow}RC${nc}/" -e "s/PostgreSQLConnection/${blue}CO${nc}/"
