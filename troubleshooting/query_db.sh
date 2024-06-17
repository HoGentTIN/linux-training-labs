#! /usr/bin/env bash
#
# Run SQL query on db server to verify its availability

demo_database='demo'
demo_table='demo_tbl'
demo_user='demo_user'
demo_password='ArfovWap_OwkUfeaf4'

set -x
mysql --host=192.168.76.73 \
  --user="${demo_user}" \
  --password="${demo_password}" \
  "${demo_database}" \
  --execute="SELECT * FROM ${demo_table};"
{ set +x; } 2>/dev/null
