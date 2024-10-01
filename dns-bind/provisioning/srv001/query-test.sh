#! /bin/bash
# Run DNS queries against our BIND server

# Variables
readonly domain="linuxtrn.lan"
readonly server="localhost"
readonly query="dig @${server} +short"

printf '\n=== A records ===\n'

printf 'srv001 -> '
${query} "srv001.${domain}"
printf 'srv002 -> '
${query} "srv002.${domain}"
printf 'srv003 -> '
${query} "srv003.${domain}"
printf 'srv004 -> '
${query} "srv004.${domain}"
printf '@      -> '
${query} "${domain}"

printf '\n=== CNAME records ===\n'

printf 'www  -> '
${query} "www.${domain}"
printf 'smtp -> '
${query} "smtp.${domain}"
printf 'imap -> '
${query} "imap.${domain}"

printf '\n=== MX record ===\n'

${query} MX "${domain}"

printf '\n=== NS records ===\n'

${query} NS "${domain}"

printf '\n=== SOA record ===\n'

${query} SOA "${domain}"

printf '\n=== Zone transfer ===\n'

${query} AXFR ${domain}
