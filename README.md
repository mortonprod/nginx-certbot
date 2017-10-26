# nginx-certbot

Based on repository you can find here
[Based on](https://bitbucket.org/automationlogic/le-docker-compose/overview)

1. Add networks so app and nginx compose fill separate completely separated.
2 Use DNS host name in nginx so we can stop and start containers to different IP addresses


## Running
1.Must start app and check component lives in app__default network.

2. Build and run nginx-certbox
```
docker-compose build 
docker-compose up
``` 

This will make certbot call through nginx to get cert. Once cert arrived your want reload config so we redirect to https when http requested.
Old config is deleted since we will not need ti again.
Any new app added should run in a a new network(default with docker-compose up)),connect nginx to new network,  update nginx config, then restart nginx.

To connect container to new network.
```
docker network connect multi-host-network container1
```
To restart nginx find process and run 

```
docker exec ledockercompose_nginx_1 nginx -s reload
```


To update cert rerun certbot 

```
docker-compose run letsencrypt
```

and reload nginx
