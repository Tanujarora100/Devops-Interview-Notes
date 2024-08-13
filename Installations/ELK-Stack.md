```sh
# ElasticSearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.2-amd64.deb
sudo dpkg -i elasticsearch-7.10.2-amd64.deb
#KIBANA
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.14.3-amd64.deb
shasum -a 512 kibana-8.14.3-amd64.deb 
sudo dpkg -i kibana-8.14.3-amd64.deb
```
1. Edit the configuration file /etc/elasticsearch/elasticsearch.yml:
 - network.host: localhost
 2. Create a configuration file /etc/logstash/conf.d/logstash.conf:

 ```json
 input {
  file {
    path => "/var/log/kibana/logfile.log"
    start_position => "beginning"
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "logstash-%{+YYYY.MM.dd}"
  }
}
 ```
  3. Check the elastic search status
 ```sh
 curl -X GET "localhost:9200"
 ```
 ```json
 {
  "name" : "prom-server",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "klr7dSGUTTuWoi2PQByDng",
  "version" : {
    "number" : "7.10.2",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "747e1cc71def077253878a59143c1f785afa92b9",
    "build_date" : "2021-01-13T00:42:12.435326Z",
    "build_snapshot" : false,
    "lucene_version" : "8.7.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
 ```
 According to the official documentation, you should install Kibana only after installing Elasticsearch. Installing in this order ensures that the components each product depends on are correctly in place.

- Because you’ve already added the Elastic package source in the previous step, you can just install the remaining components of the Elastic Stack using apt:

- `sudo apt install kibana`
    - Then enable and start the Kibana service:

- `sudo systemctl enable kibana`
- `sudo systemctl start kibana`
- Because Kibana is configured to only listen on localhost, we must set up a reverse proxy to allow external access to it. We will use Nginx for this purpose, which should already be installed on your server.

First, use the openssl command to create an administrative Kibana user which you’ll use to access the Kibana web interface. As an example we will name this account kibanaadmin, but to ensure greater security we recommend that you choose a non-standard name for your user that would be difficult to guess.

The following command will create the administrative Kibana user and password, and store them in the htpasswd.users file. You will configure Nginx to require this username and password and read this file momentarily:

`echo "kibanaadmin:`openssl passwd -apr1`" | sudo tee -a /etc/nginx/htpasswd.users`
Enter and confirm a password at the prompt. `Remember or take note of this login, as you will need it to access the Kibana web interface.`

Next, we will create an Nginx server block file. 
- As an example, we will refer to this file as your_domain, although you may find it helpful to give yours a more descriptive name. For instance, if you have a FQDN and DNS records set up for this server, you could name this file after your FQDN.

Using nano or your preferred text editor, create the Nginx server block file:

`sudo nano /etc/nginx/sites-available/34.45.152.20`
Add the following code block into the file, being sure to update your_domain to match your server’s FQDN or public IP address. This code configures Nginx to direct your server’s HTTP traffic to the Kibana application, which is listening on localhost:5601. Additionally, it configures Nginx to read the htpasswd.users file and require basic authentication.


/etc/nginx/sites-available/34.45.152.20
```json
server {
    listen 80;

    server_name 34.45.152.20;

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;

    location / {
        proxy_pass http://localhost:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```
When you’re finished, save and close the file.

Next, enable the new configuration by creating a symbolic link to the sites-enabled directory. If you already created a server block file with the same name in the Nginx prerequisite, you do not need to run this command:
sudo filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'
