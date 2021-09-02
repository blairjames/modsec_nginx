#### Nginx compiled with Modsecurity connector module, Modsecurity and the Core Rule Set.

- https://github.com/SpiderLabs/ModSecurity
- https://github.com/SpiderLabs/ModSecurity-nginx
- https://github.com/coreruleset/coreruleset

#### Use:
- Map your nginx.conf to: /usr/local/nginx/conf/nginx.conf
- Map your CRS conf file to: /usr/local/modsecurity/rules/crs-setup.conf

#### Docker Compose example:
```
volumes:
      - "./nginx/nginx.conf:/usr/local/nginx/conf/nginx.conf"
      - "./nginx/coreruleset/crs-setup.conf:/usr/local/modsecurity/rules/crs-setup.conf"
```

