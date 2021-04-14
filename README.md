# What
  Here you will find a reverse proxy for rsk nodes. There are two options that may fit your scenario:
  
  * **HTTPS:** This is the typical setup when you want to deal with certificates, proxy and node into one and only instance, host, box etc...
  * **HTTP:** This is the typical case when you want to setup up a proxy; but behind a load balancer, haproxy or any device that manage your certificates. For instance, an AWS Load Balancer managing the certificates and pushing the traffic to one or more boxes with this stack running.

#  Before start

You need to install the following tools:

* git
* docker-compose
* Working domain accesible from Internet. For instance, you can get the Ip address executing the following command:
  
```bash
$ nslookup rskj-node.example.com
``` 
* TCP ports accessible from the internet:
  * 4444    (Node listening for JSON-RPC traffic)
  * 4445    (For websocket)
  * 50505   (For testnet network)
  * 5050    (For mainnet network)
  * 80      
    * For HTTPS scenario, open to the world
    * For HTTP scenario, only required from the devices performing a healthcheck
  * 443
    * For HTTPS scenario, open to the world
    * For HTTP scenario, keep it closed
  * 8080 for Traefik API (not recommended to open this to the world)

# Setup the rskj config files
According to your environment (testnet or mainnet) you need to setup the following:

* **rskj/node.conf:** Look for the following files
  - __rpc.providers.web.cors__: Restricts the RPC calls from other domains. Select `*` for any.
  - __rpc.providers.web.http.hosts__: Switch `host.example.co` to your working domain.
  - __blockchain.config.name__: A string that describe the name of the configuration and matches the network environment, this is `testnet` or `mainnet`. Uncomment or comment the desired environment.
  - __peer.discovery.ip.list__: A list of the peers to start the discovering. Uncomment / comment according to the environment selected in the previous `blockchain.config.name`. The commented `5050` belongs to Mainnet, uncommented `50505` belongs to Testnet.

# HTTPS Scenario

On this case, we are setting up a standalone rskj node with a traefik proxy in front. On this setup we are delegating the cert management to traefik.

By default, **we are setting up a testnet environment node.** If you want to setup a mainnet node you must make some modifications instructed on this README..


## Setup the docker-compose env files
Open the `.env` file and edit as follows

* **NODE_URL**: The URL of the node reachable from Internet. Refer to *Before start* section. 
* **API_INSECURE**: If you want to open the traefik API without https. Open port `8080`.
* **TAG**: Tag of the traefik docker image.
* **RSKJ_ENTRYPOINT**: Enter **websecure**. This entrypoint is to setup as a monolitic standalone https rsk node. This option will usually fit if you have a box directly connected to the internet.
* **TLS_CERTRESOLVER**: Is the resolver under `traefik.toml`. Usually leave it as it is, unless you know what you are doing. 

## Setup the traefik container configuration files

On the `proxy/traefik.toml` file:

Set the mail address to manage the certificates. This mail address is the one Let's Encrypt will use to communicate about cert issues.
```toml
...
[certificatesResolvers.rskj.acme]
email = "mail@domain.com"
...
```

Set the following permission on `proxy/acme.json`, else the cert issuing challenge will fail.
```
$ chmod 400 proxy/acme.json
```

# HTTP Scenario
## Setup the docker-compose env files
Open the `.env` file and edit as follows

* **NODE_URL**: The URL of the node reachable from Internet. Refer to *Before start* section. 
* **API_INSECURE**: If you want to open the traefik API without https. Open port `8080`.
* **TAG**: Tag of the traefik docker image.
* **RSKJ_ENTRYPOINT**: Enter **web**: Set this entrypoint to this one to enable the access via http. In the next section we are going to specify in `docker-compose.yml` file to use this one.
* **TLS_CERTRESOLVER**: This is not used in http. So feel free to comment this line.

## Remove the cert issuing section
On `proxy/traefik.toml` remove the following section

```toml
[certificatesResolvers.rskj.acme]
  email = "mail@domain.com"
  storage = "/acme.json"
  [certificatesResolvers.rskj.acme.httpChallenge]
    entryPoint = "web"
```

## Setup the entrypoints
On `docker-compose.yml` open and edit as follows:
* Comment, `- ./proxy/acme.json:/acme.json` since we are not saving any cert.
* Comment, `- "traefik.http.routers.rskj-node.tls.certresolver=${TLS_CERTRESOLVER}"` since we are not using any metho to resolve the cert issuing.
  
## If you are using a Load Balancer
If you are using some kind of load balancing or any device between internet and the traefik proxy, keep in mind:

* Forward traffic JSON-RPC traffic from port 80 or 443 from the Load Balancer to port 4444 or 4445 for websocket.
* Send the health status or keepalive to 


# Starting the stack
Only need to execute:
```bash
$ sudo docker-compose up -d 
```

M

aybe, to see what's going on [here](TRACK.md)
