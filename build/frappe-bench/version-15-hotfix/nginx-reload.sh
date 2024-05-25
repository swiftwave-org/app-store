# !/bin/bash

cd /home/frappe/frappe-bench && \
  bench setup nginx --yes && \
  cp /home/frappe/frappe-bench/config/nginx.conf /etc/nginx/conf.d/frappe-bench.conf && \
  supervisorctl restart frappe-bench-web:frappe-nginx