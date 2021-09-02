FROM centos:latest AS original
RUN dnf -y update && \
    dnf -y install \
    git \
    wget \
    libtool.x86_64 \
    gcc-c++.x86_64 \
    libcurl-devel.x86_64 \
    libxml2-devel.x86_64 \
    pcre-devel.x86_64 \
    make.x86_64 \
    make-devel.x86_64 \
    lsof

# modsec source
RUN git clone https://github.com/SpiderLabs/ModSecurity.git && \
  cd /ModSecurity && \
  git submodule init && git submodule update && \
  ./build.sh && \
  ./configure --disable-dependency-tracking && \
  make -j 32 && \
  make install -j 32

# connector module
RUN git clone https://github.com/SpiderLabs/ModSecurity-nginx.git && \
  wget http://nginx.org/download/nginx-1.20.1.tar.gz && \
  tar -zxvf ./nginx*tar.gz && \
  cd ./nginx-1.20.1 && \
  ./configure --add-module=/ModSecurity-nginx && \
  make -j 16 && make install -j 16 && \
  # Get latest CRS
  mkdir /usr/local/modsecurity/rules && cd /usr/local/modsecurity/rules && \
  git clone https://github.com/coreruleset/coreruleset.git && \
  cp /usr/local/modsecurity/rules/coreruleset/crs-setup.conf.example ./crs-setup.conf

# Start again from clean image to remove compilation artifacts
# Copy Nginx and Modsec to new image
FROM centos:latest
RUN dnf -y update
COPY --from=original /usr/local/nginx /usr/local/nginx
COPY --from=original /usr/local/modsecurity /usr/local/modsecurity
ENV PATH=/usr/local/nginx/sbin:$PATH
EXPOSE 80
STOPSIGNAL SIGQUIT
CMD ["/usr/local/nginx/sbin/nginx","-g","daemon off;"]