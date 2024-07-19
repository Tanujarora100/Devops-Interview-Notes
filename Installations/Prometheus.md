To set up Prometheus and Node Exporter on your machine, follow the steps below:

## **Install Prometheus**

1. **Download Prometheus:**
   Go to the [Prometheus download page](https://prometheus.io/download/) and download the latest release for your operating system. For example, on a Linux machine, you can use the following commands:
   ```bash
   wget https://github.com/prometheus/prometheus/releases/download/v2.53.1/prometheus-2.53.1.linux-amd64.tar.gz
   tar xvfz prometheus-*.tar.gz
   cd prometheus-*
   ```

2. **Configure Prometheus:**
   Create a configuration file named `prometheus.yml` with the following content:
   ```yaml
   global:
     scrape_interval: 15s

   scrape_configs:
     - job_name: 'prometheus'
       static_configs:
         - targets: ['localhost:9090']
   ```

3. **Run Prometheus:**
   Start Prometheus with the configuration file:
   ```bash
   ./prometheus --config.file=prometheus.yml
   ```
   Prometheus will now be running and accessible at `http://localhost:9090`.

## **Install Node Exporter**

1. **Download Node Exporter:**
   Download the latest Node Exporter release from the [Prometheus downloads page](https://prometheus.io/download/). For example, on a Linux machine, you can use the following commands:
   ```bash
   wget https://github.com/prometheus/node_exporter/releases/download/v<VERSION>/node_exporter-<VERSION>.linux-amd64.tar.gz
   tar xvfz node_exporter-*.linux-amd64.tar.gz
   cd node_exporter-*
   ```

2. **Run Node Exporter:**
   Start the Node Exporter:
   ```bash
   ./node_exporter
   ```
   Node Exporter will now be running and accessible at `http://localhost:9100`.

## **Configure Prometheus to Scrape Node Exporter**

1. **Edit Prometheus Configuration:**
   Edit the `prometheus.yml` file to add a new scrape job for Node Exporter:
   ```yaml
   global:
     scrape_interval: 15s

   scrape_configs:
     - job_name: 'prometheus'
       static_configs:
         - targets: ['localhost:9090']
     - job_name: 'node'
       static_configs:
         - targets: ['localhost:9100']
   ```

2. **Restart Prometheus:**
   Restart Prometheus to apply the new configuration:
   ```bash
   ./prometheus --config.file=prometheus.yml
   ```

## **Verify Setup**

1. **Access Prometheus UI:**
   Open your browser and go to `http://localhost:9090`. You should see the Prometheus UI.

2. **Check Node Exporter Metrics:**
   In the Prometheus UI, go to the "Status" -> "Targets" page. You should see both Prometheus and Node Exporter listed as targets. They should be in the "UP" state.

3. **Query Metrics:**
   Use the Prometheus UI to query metrics. For example, you can enter `node_cpu_seconds_total` in the expression bar to see CPU metrics collected by Node Exporter.

By following these steps, you will have Prometheus and Node Exporter set up on your machine, allowing you to monitor system metrics effectively.

#### Install Blackbox Exporter
Download Blackbox Exporter:
```bash
wget https://github.com/prometheus/blackbox_exporter/releases/download/v<VERSION>/blackbox_exporter-<VERSION>.linux-amd64.tar.gz
tar xvfz blackbox_exporter-*.linux-amd64.tar.gz
cd blackbox_exporter-*
```
#### Run Blackbox Exporter:
```bash
./blackbox_exporter --config.file=blackbox.yml
```
Create Configuration File:
Create a blackbox.yml file:
```yaml
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
      valid_status_codes: []  # Defaults to 2xx
      method: GET
      no_follow_redirects: false
      fail_if_ssl: false
      fail_if_not_ssl: false

Configure Prometheus to Scrape Blackbox Exporter:
Update prometheus.yml:
text
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]
    static_configs:
      - targets:
        - http://example.com
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: localhost:9115
```
Restart Prometheus:
```sh
./prometheus --config.file=prometheus.yml
```
Verify Setup
Access Prometheus UI:
Open http://localhost:9090 in your browser.
Check Targets:
- Go to "Status" -> "Targets" in the Prometheus UI. You should see Prometheus, Node Exporter, and Blackbox Exporter listed as targets.
Query Metrics:
- Use the Prometheus UI to query metrics, such as node_cpu_seconds_total for Node Exporter and probe_success for Blackbox Exporter.
- By following these steps, you will have Prometheus, Node Exporter, and Blackbox Exporter set up on your machine, enabling comprehensive monitoring of system metrics and external endpoints.
```yaml
version: "3.3"

networks:
  net:

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    hostname: prometheus
    restart: always
    tty: true
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - 9090:9090

    networks:
      - net

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    hostname: grafana
    environment:
      - GF_AUTH_PROXY_ENABLED=true
      - GF_PATHS_PROVISIONING=/var/lib/grafana/provisioning/
    volumes:
      - ./provisioning/:/var/lib/grafana/provisioning/
      - ./grafana.ini:/etc/grafana/grafana.ini
    ports:
      - 3000:3000
    networks:
      - net
    depends_on:
      - prometheus
```