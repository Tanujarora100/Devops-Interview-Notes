
### Step 1: Install Prometheus
1. **Download Prometheus**:

   ```bash
   wget https://github.com/prometheus/prometheus/releases/download/v2.41.0/prometheus-2.41.0.linux-amd64.tar.gz
   ```

2. **Extract and move to the appropriate directory**:

   ```bash
   tar xvf prometheus-*.tar.gz
   cd prometheus-*
   sudo mv prometheus /usr/local/bin/
   sudo mv promtool /usr/local/bin/
   sudo mkdir -p /etc/prometheus
   sudo mv prometheus.yml /etc/prometheus/
   ```

3. **Create a Prometheus systemd service**:

   ```bash
   sudo nano /etc/systemd/system/prometheus.service
   ```

   Add the following content:

   ```ini
   [Unit]
   Description=Prometheus
   After=network.target

   [Service]
   Type=simple
   ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

4. **Start and enable Prometheus**:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start prometheus
   sudo systemctl enable prometheus
   ```
    ![alt text](image.png)
### Step 2: Install Node Exporter

1. **Download Node Exporter**:

   ```bash
   wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
   ```

2. **Extract and move to the appropriate directory**:

   ```bash
   tar xvf node_exporter-*.tar.gz
   cd node_exporter-*
   sudo mv node_exporter /usr/local/bin/
   ```

3. **Create a Node Exporter systemd service**:

   ```bash
   sudo nano /etc/systemd/system/node_exporter.service
   ```

   Add the following content:

   ```ini
   [Unit]
   Description=Node Exporter
   After=network.target

   [Service]
   Type=simple
   ExecStart=/usr/local/bin/node_exporter
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

4. **Start and enable Node Exporter**:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start node_exporter
   sudo systemctl enable node_exporter
   ```

### Step 3: Configure Prometheus to scrape Node Exporter

1. **Edit Prometheus configuration**:

   ```bash
   sudo nano /etc/prometheus/prometheus.yml
   ```

   Add the following under the `scrape_configs` section:

   ```yaml
   - job_name: 'node_exporter'
     static_configs:
       - targets: ['localhost:9100']
   ```

2. **Restart Prometheus**:

   ```bash
   sudo systemctl restart prometheus
   ```

### Step 4: Install Grafana

1. **Download Grafana**:

   ```bash
   wget https://dl.grafana.com/oss/release/grafana-10.1.5-1.x86_64.rpm
   ```

2. **Install Grafana**:

   ```bash
   sudo apt install grafana-10.1.5-1.x86_64.rpm
   ```

3. **Start and enable Grafana**:

   ```bash
   sudo systemctl start grafana-server
   sudo systemctl enable grafana-server
   ```

### Step 5: Configure Grafana

1. **Access Grafana**: Open your web browser and go to `http://<your-server-ip>:3000`. The default login is `admin` for both username and password.

2. **Add Prometheus as a data source**:
   - Navigate to Configuration > Data Sources.
   - Click on "Add data source" and select "Prometheus".
   - Set the URL to `http://<your-server-ip>:9090`.
   - Click "Save & Test" to ensure it connects successfully.

3. **Create a dashboard**:
   - Navigate to Dashboards > + New Dashboard.
   - Add panels and choose the appropriate metrics from Prometheus.

### Security Note
- Ensure that Prometheus and Node Exporter are not exposed to the internet without proper security measures (e.g., firewalls, VPNs).
- Change default passwords and enable authentication for Grafana.

The `localhost:9100` in the Prometheus configuration refers to the Node Exporter running on the same machine as Prometheus. Node Exporter is a Prometheus exporter for hardware and OS metrics. By default, it runs on port 9100.

To monitor multiple servers, you'll need to install Node Exporter on each server you want to monitor and then configure Prometheus to scrape metrics from these additional servers.

Here’s how to do it step by step:

### Step 1: Install Node Exporter on Additional Servers

Repeat the installation steps for Node Exporter on each additional server:

1. **Download Node Exporter** on the additional server:

   ```bash
   wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
   ```

2. **Extract and move to the appropriate directory**:

   ```bash
   tar xvf node_exporter-*.tar.gz
   cd node_exporter-*
   sudo mv node_exporter /usr/local/bin/
   ```

3. **Create a Node Exporter systemd service**:

   ```bash
   sudo nano /etc/systemd/system/node_exporter.service
   ```

   Add the following content:

   ```ini
   [Unit]
   Description=Node Exporter
   After=network.target

   [Service]
   Type=simple
   ExecStart=/usr/local/bin/node_exporter
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

4. **Start and enable Node Exporter**:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start node_exporter
   sudo systemctl enable node_exporter
   ```

### Step 2: Configure Prometheus to Scrape Metrics from Multiple Servers

1. **Edit the Prometheus configuration file (`/etc/prometheus/prometheus.yml`)**:

   ```bash
   sudo nano /etc/prometheus/prometheus.yml
   ```

2. **Add the additional server targets to the `scrape_configs` section**. For example:

   ```yaml
   scrape_configs:
     - job_name: 'node_exporter'
       static_configs:
         - targets: ['localhost:9100', 'server1:9100', 'server2:9100']
   ```

   Replace `server1` and `server2` with the actual hostnames or IP addresses of your additional servers.

3. **Restart Prometheus** to apply the changes:

   ```bash
   sudo systemctl restart prometheus
   ```

### Step 3: Verify the Configuration

1. **Access Prometheus**: Open your web browser and go to `http://<your-prometheus-server-ip>:9090/targets`.
   
   You should see all your configured targets listed, and their status should be "UP".

### Step 4: Update Grafana Dashboard

1. **Access Grafana**: Open your web browser and go to `http://<your-grafana-server-ip>:3000`.

2. **Add Prometheus as a Data Source (if not already added)**:
   - Navigate to Configuration > Data Sources.
   - Click on "Add data source" and select "Prometheus".
   - Set the URL to `http://<your-prometheus-server-ip>:9090`.
   - Click "Save & Test" to ensure it connects successfully.

3. **Create or Update Dashboard**:
   - Navigate to Dashboards > + New Dashboard.
   - Add panels and choose the appropriate metrics from Prometheus.
   - You can use the hostname labels to filter metrics for different servers.

### Example Prometheus Configuration (`prometheus.yml`)

Here's a complete example of the Prometheus configuration with multiple servers:

```yaml
global:
  scrape_interval: 15s # Default scrape interval

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100', '192.168.1.2:9100', '192.168.1.3:9100']
```

