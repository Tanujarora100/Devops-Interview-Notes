
1. **Download Alertmanager**:

   ```bash
   wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz
   ```

2. **Extract and move to the appropriate directory**:

   ```bash
   tar xvf alertmanager-*.tar.gz
   cd alertmanager-*
   sudo mv alertmanager /usr/local/bin/
   sudo mkdir -p /etc/alertmanager
   sudo mv alertmanager.yml /etc/alertmanager/
   ```

3. **Create an Alertmanager systemd service**:

   ```bash
   sudo nano /etc/systemd/system/alertmanager.service
   ```

   Add the following content:

   ```ini
   [Unit]
   Description=Alertmanager
   After=network.target

   [Service]
   Type=simple
   ExecStart=/usr/local/bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

4. **Start and enable Alertmanager**:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start alertmanager
   sudo systemctl enable alertmanager
   ```

### Step 2: Configure Alertmanager

1. **Edit the `alertmanager.yml` configuration file**:

   ```bash
   sudo nano /etc/alertmanager/alertmanager.yml
   ```

   Basic configuration to send alerts via email:

   ```yaml
   global:
     smtp_smarthost: 'smtp.example.com:587'
     smtp_from: 'alertmanager@example.com'
     smtp_auth_username: 'your_username'
     smtp_auth_password: 'your_password'

   route:
     receiver: 'email-notifications'
     group_by: ['alertname']

   receivers:
     - name: 'email-notifications'
       email_configs:
         - to: 'your_email@example.com'
   ```

### Step 3: Configure Prometheus to Use Alertmanager

1. **Edit the Prometheus configuration file (`/etc/prometheus/prometheus.yml`)**:

   ```bash
   sudo nano /etc/prometheus/prometheus.yml
   ```

2. **Add Alertmanager configuration**:

   ```yaml
   alerting:
     alertmanagers:
       - static_configs:
           - targets:
             - 'localhost:9093'

   rule_files:
     - /etc/prometheus/alert.rules.yml
   ```

### Step 4: Define Alerting Rules

1. **Create an alerting rules file (`/etc/prometheus/alert.rules.yml`)**:

   ```bash
   sudo nano /etc/prometheus/alert.rules.yml
   ```

2. **Add alerting rules**:

   ```yaml
   groups:
     - name: blackbox_alerts
       rules:
         - alert: InstanceDown
           expr: probe_success == 0
           for: 1m
           labels:
             severity: critical
           annotations:
             summary: "Instance {{ $labels.instance }} down"
             description: "Instance {{ $labels.instance }} has been down for more than 1 minute."
   ```

3. **Restart Prometheus** to apply the changes:

   ```bash
   sudo systemctl restart prometheus
   ```