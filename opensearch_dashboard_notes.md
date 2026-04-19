## Setting up Fluent Bit (100% Open Source) on Ubuntu VM

Because Elastic changed their license to a non-open-source model for versions 7.11+, the industry standard for OpenSearch is to use **Fluent Bit** (a CNCF graduated project under Apache 2.0 license).

1. **Install Fluent Bit:**
```bash
curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh
```

2. **Configure Fluent Bit (`/etc/fluent-bit/fluent-bit.conf`):**
Replace the default config to tell Fluent Bit to read logs and send them to OpenSearch:

```ini
[SERVICE]
    Flush        1
    Log_Level    info
    Parsers_File parsers.conf

[INPUT]
    Name         tail
    Path         /home/*/demoProjectLogs/tasosApp.json
    Tag          springboot_logs
    Parser       json
    Mem_Buf_Limit 5MB
    Read_from_Head On

[INPUT]
    Name         tail
    Path         /home/*/demoProjectLogs/access_log*.log
    Tag          tomcat_access
    Mem_Buf_Limit 5MB
    Read_from_Head On

[OUTPUT]
    Name            opensearch
    Match           springboot_logs
    Host            10.0.0.71
    Port            9200
    HTTP_User       admin
    HTTP_Passwd     admin
    Logstash_Format     On
    Logstash_Prefix     springboot-app-logs
    tls             On
    tls.verify      Off
    Suppress_Type_Name On

[OUTPUT]
    Name            opensearch
    Match           tomcat_access
    Host            10.0.0.71
    Port            9200
    HTTP_User       admin
    HTTP_Passwd     admin
    Logstash_Format     On
    Logstash_Prefix     tomcat-access-logs
    tls             On
    tls.verify      Off
    Suppress_Type_Name On
```

3. **Start the Service:**
```bash
sudo systemctl enable fluent-bit
sudo systemctl start fluent-bit
```

---

## Viewing Logs & Geolocation in OpenSearch Dashboards

With Fluent Bit active on Ubuntu, **OpenSearch Dashboards** will now receive logs automatically!

1. Log in to Dashboards.
2. Under **Stack Management > Index Patterns**, will see your indices. Click **Create index pattern**.
3. Type `springboot-logs*` and select `@timestamp`.
4. Go back to **Discover**. In the dropdown menu, select `springboot-logs*` and you'll see all your Application logs flowing beautifully.

Because of the framework properties we added in `application.properties` (`server.forward-headers-strategy=framework` alongside `RemoteIpValve`), Tomcat inherently strips the `127.0.0.1` reverse-proxy Nginx IP natively on the server level, permanently ensuring your Spring Logs *and* your Tomcat access logs print the actual Remote User Client IP `85.73.121.153` from the `X-Forwarded-For` header. OpenSearch natively turns this IP into Lat/Long Map Coordinates inside Dashboards!
