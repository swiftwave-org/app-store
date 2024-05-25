FROM ubuntu:22.04 AS main

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV OPENBLAS_NUM_THREADS 1
ENV MKL_NUM_THREADS 1
ENV PYTHONUNBUFFERED 1
ENV FRAPPE_HARD_LINK_ASSETS True

# Version of tools
ENV PYTHON_VERSION 3.11
ENV NODE_VERSION 18.16.0
ENV BENCH_VERSION 5.22.6
ENV FRAPPE_BRANCH version-15-hotfix

# Install system packages
RUN apt-get update && apt-get install --yes --no-install-suggests --no-install-recommends \
  # Init
  build-essential gcc gnupg ca-certificates git mariadb-client libmariadb-dev pv ntp lsb-release wget curl supervisor file nano vim less htop iputils-ping telnet software-properties-common libmagic1 libcups2-dev \
  # weasyprint
  libpango-1.0-0 libharfbuzz0b libpangoft2-1.0-0 libpangocairo-1.0-0 \
  # wkhtmltopdf
  fontconfig libfreetype6 libjpeg-turbo8 libpng16-16 libx11-6 libxcb1 libxext6 libxrender1 xfonts-75dpi xfonts-base xvfb libfontconfig \
  # nginx
  nginx \
  # Cleanup
  && rm -rf /var/lib/apt/lists/*

# Add frappe non-root user
RUN useradd -ms /bin/bash -u 1000 frappe

# Install libssl1.1
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
  dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
  rm libssl1.1_1.1.0g-2ubuntu4_amd64.deb

# Install Python and pip
RUN add-apt-repository ppa:deadsnakes/ppa \
  && apt-get update \
  && apt-get install --yes --no-install-suggests --no-install-recommends \
  python${PYTHON_VERSION} \
  python${PYTHON_VERSION}-dev \
  python${PYTHON_VERSION}-venv \
  python${PYTHON_VERSION}-distutils \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*

# Install Node
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install --yes --no-install-suggests --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g yarn

# Install Redis
RUN curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list \
  && apt-get update \
  && apt-get install --yes --no-install-suggests --no-install-recommends redis \
  && rm -rf /var/lib/apt/lists/*

# Install wkhtmltopdf
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.focal_amd64.deb \
  && dpkg -i wkhtmltox_0.12.5-1.focal_amd64.deb \
  && rm wkhtmltox_0.12.5-1.focal_amd64.deb

# Install Fonts
RUN git clone --progress --depth 1 https://github.com/frappe/fonts.git /tmp/fonts \
  && rm -rf /etc/fonts && mv /tmp/fonts/etc_fonts /etc/fonts \
  && rm -rf /usr/share/fonts && mv /tmp/fonts/usr_share_fonts /usr/share/fonts \
  && rm -rf /tmp/fonts \
  && fc-cache -fv

# Switch to user frappe
USER frappe
WORKDIR /home/frappe

# Install Bench
ENV PATH "$PATH:/home/frappe/.local/bin"
RUN python${PYTHON_VERSION} -m pip install --upgrade frappe-bench==${BENCH_VERSION}

# Install Frappe app
RUN bench init --python /usr/bin/python${PYTHON_VERSION} --no-backups frappe-bench

# Install pycups for print server
RUN /home/frappe/frappe-bench/env/bin/pip install pycups==2.0.1

# Copy files
COPY --chown=frappe:frappe ./entrypoint.sh /home/frappe/entrypoint.sh
RUN chmod +x /home/frappe/entrypoint.sh
COPY --chown=frappe:frappe nginx-reload.sh /usr/bin/nginx-reload
COPY --chown=root:root nginx-default.conf /etc/nginx/nginx.conf
COPY --chown=root:root supervisord.conf /etc/supervisor/supervisord.conf
COPY --chown=frappe:frappe .vimrc /home/frappe/.vimrc
COPY --chown=frappe:frappe redis /home/frappe/frappe-bench/redis
COPY --chown=frappe:frappe common_site_config.json /home/frappe/frappe-bench/sites/common_site_config.json
COPY --chown=frappe:frappe config /home/frappe/frappe-bench/config

# Set workdir
WORKDIR /home/frappe/frappe-bench

# Enable DNS multitenancy
RUN bench config dns_multitenant on

# Generate default nginx config and create symlink
RUN bench setup nginx

# Change permissions of nginx to run as non-root user
USER root

RUN mkdir -p /var/cache/nginx \
  && chown -R 1000:0 /var/cache/nginx \
  && chmod -R g+w /var/cache/nginx \
  && mkdir -p /etc/nginx \
  && chown -R 1000:0 /etc/nginx \
  && chmod -R g+w /etc/nginx \
  && mkdir -p /var/log/nginx \
  && chown -R 1000:0 /var/log/nginx \
  && chmod -R g+w /var/log/nginx \
  && mkdir -p /var/run/nginx \
  && chown -R 1000:0 /var/run/nginx \
  && chmod -R g+w /var/run/nginx \
  && touch /run/nginx.pid \
  && chown 1000:0 /run/nginx.pid \
  && chmod g+w /run/nginx.pid \
  && mkdir -p /var/lib/nginx \
  && chown -R 1000:0 /var/lib/nginx \
  && chmod -R g+w /var/lib/nginx \
  && ln -s `pwd`/config/nginx.conf /etc/nginx/conf.d/frappe-bench.conf

USER frappe

EXPOSE 80

CMD ["bash", "/home/frappe/entrypoint.sh"]