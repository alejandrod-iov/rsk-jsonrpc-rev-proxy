# Advices or things to keep in mind for debugging

Bellow you will find some advices, things to check or keep in mind to track or monitor or at least know what's going on.

## For https

Some things to keep in mind when starting an https scenario
### Where are the logs of the rskj node?
1. Look for the complete VOLUME NAME from **log** volume, **In my example:**
```bash
$ sudo docker volume ls
```
```bash
DRIVER              VOLUME NAME
local               rskjsonrpcrevproxy_rskj-database
local               rskjsonrpcrevproxy_rskj-log
```
2. Look for the mount point (you need jq installed), **In my example:**
```bash
$ sudo docker volume inspect rskjsonrpcrevproxy_rskj-log | jq -r .[].Mountpoint
```
```bash
/var/lib/docker/volumes/rskjsonrpcrevproxy_rskj-log/_data
```
3. Tail the logs:
```bash
sudo tail -f /var/lib/docker/volumes/rskjsonrpcrevproxy_rskj-log/_data/rsk.log
```

### Save the certificate material
The certificate material is saved under the `acme.json` file and is mounted everytime the container starts. On the first run will get the certificate, and on the following runs will use the content of this file as cert material for https.
If too many certs are requested, Let's Encrypt will ban the domain. Refer [here](https://letsencrypt.org/docs/rate-limits/) for cert issuing rate limit. To avoid getting banned a good practice is to backup the `acme.json` file after a succesful issuing.
```bash
$ cp -axuv acme.json /backup/folder/acme.json
```

### Look for cert issuing
To look on what happened on certificate issuing you may look for two lines:
1. `Certificates obtained`, if there is a new cert issuing look for a line similar to:
  ```bash
  level=debug msg="Certificates obtained for domains [host.example.co]"
  ```
2. Else, if the certificate was already issued, there is no need to generate a new one. Look for a line similar to
```bash
level=debug msg="No ACME certificate generation required for domains [\"host.example.co\"]
```

### Test https RPC calls
From another instance, box, computer execute:

```bash
curl -s -X POST \
-H "Content-Type: application/json" \
-d '{"jsonrpc":"2.0","method":"eth_blockNumber", "params": {},  "id":666}' \
https://host.example.co -vvvv
```
And must return the hexa block height:
```json
{"jsonrpc":"2.0","id":666,"result":"0x1db"}
```

## For http
Some things to keep in mind when starting an http scenario

### Test https RPC calls
From another instance, box, computer execute a query against the load balancer:

```bash
curl -s -X POST \
-H "Content-Type: application/json" \
-d '{"jsonrpc":"2.0","method":"eth_blockNumber", "params": {},  "id":666}' \
https://loadbalancer.host.co -vvvv
```
And must return the hexa block height:
```json
{"jsonrpc":"2.0","id":666,"result":"0x1db"}
```

### Where are the logs of the rskj node?
1. Look for the complete VOLUME NAME from **log** volume, **In my example:**
```bash
$ sudo docker volume ls
```
```bash
DRIVER              VOLUME NAME
local               rskjsonrpcrevproxy_rskj-database
local               rskjsonrpcrevproxy_rskj-log
```
2. Look for the mount point (you need jq installed), **In my example:**
```bash
$ sudo docker volume inspect rskjsonrpcrevproxy_rskj-log | jq -r .[].Mountpoint
```
```bash
/var/lib/docker/volumes/rskjsonrpcrevproxy_rskj-log/_data
```
3. Tail the logs:
```bash
sudo tail -f /var/lib/docker/volumes/rskjsonrpcrevproxy_rskj-log/_data/rsk.log
```