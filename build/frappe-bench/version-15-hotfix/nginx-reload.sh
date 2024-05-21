# !/bin/bash

cd /home/frappe/frappe-bench && \
  bench setup nginx --yes && \
  supervisorctl restart frappe-bench-web:frappe-nginx