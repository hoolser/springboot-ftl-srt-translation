# Email Setup Guide: Oracle Cloud (OCI Email Delivery) & Namecheap

Sending emails directly from an Oracle Cloud VM running on the Free Tier is not possible by default because Oracle Cloud blocks outbound traffic on port 25 to prevent spam. 

To reliably send emails using your custom domain (`@leaflogic.xyz`), we will use Oracle's native **OCI Email Delivery** service (included in the Always Free tier) on port 587.

Follow this complete step-by-step guide.

---

## Phase 1: Configure OCI Email Delivery & Generate Credentials

1. **Create an Approved Sender:**
   * In the Oracle Cloud Console, search for **Email Delivery**.
   * Go to **Email Domains** and click **Create Email Domain**. Enter `leaflogic.xyz` (this sets up your domain to allow sending and DKIM generation).
   * Go to **Approved Senders** and click **Create Approved Sender**.
   * Enter the exact email address you want to send from (e.g., `admin@leaflogic.xyz` or `noreply@leaflogic.xyz`).

2. **Generate Native SMTP Credentials:**
   * **IMPORTANT: If you use a Federated Login (Single Sign-On), you cannot generate SMTP credentials for your main account.** You must create a Local IAM User first.
   * Go to **Identity & Security** -> **Domains** -> **Default Domain** -> **Users**.
   * If you don't see "SMTP Credentials" for your own user, click **Create User** and create a local user (e.g., `smtp-app-user`).
   * Add this new user to the `Administrators` group (or a group with `manage email-family` permissions).
   * Click on the local user account (`smtp-app-user`).
   * Under "Resources" on the left, click **SMTP Credentials**, then click **Generate SMTP Credentials**.
   * Give it a description (e.g., "Spring Boot App").
   * **COPY NOW**: Copy the generated Username and Password immediately. You will not be able to see the password again.

3. **Find the SMTP Endpoint:**
   * Go back to **Email Delivery** -> **Configuration**.
   * Note the SMTP endpoint (e.g., `smtp.email.eu-frankfurt-1.oci.oraclecloud.com` depending on your region) and the port (usually 587).

---

## Phase 2: Namecheap DNS Configuration for Oracle

When you send an email from `@leaflogic.xyz` using Oracle, email providers (like Gmail and Outlook) will look up the DNS records of `leaflogic.xyz` to check if Oracle is actually authorized by you. 

1. Log in to your **Namecheap Dashboard**.
2. Click on **Domain List** -> find `leaflogic.xyz` -> click **Manage** -> go to the **Advanced DNS** tab.
3. Scroll down to **Host Records** and click **Add New Record**.

### 1. The SPF Record (Authorizes Oracle servers):
* **Type:** `TXT Record`
* **Host:** `@` (Type the `@` symbol)
* **Value:** `v=spf1 include:rp.oracleemaildelivery.com ~all`
* *Click the small green checkmark to save.*

### 2. The DKIM Record (Signs your emails cryptographically):
* In the Oracle Cloud Console, go to **Email Delivery** -> **Email Domains** -> click on `leaflogic.xyz` -> **DKIM** -> **Add DKIM**.
* Provide a DKIM selector name (e.g., `s1` or `selector1`). *Note: Leave the "Tag" field empty or blank unless you have a specific internal tagging strategy. It is not required.*
* Generate it.
* Oracle will provide you with a **CNAME Record** (with a Name/Host and a Value/Target).
* Back in Namecheap, click Add New Record:
  * **Type:** `CNAME Record`
  * **Host:** *Paste the exact host Oracle gives you* (e.g., `s1._domainkey` - Do NOT include `.leaflogic.xyz` at the end).
  * **Value:** *Paste the target Oracle gives you* (This will end in `.oracleemaildelivery.com`).
  * *Click the small green checkmark to save.*

### 3. The DMARC Record (Good practice, prevents domain spoofing):
* **Type:** `TXT Record`
* **Host:** `_dmarc`
* **Value:** `v=DMARC1; p=none;`
* *Click the small green checkmark to save.*

> **Wait for Propagation:** After adding these in Namecheap, it can take up to an hour to spread across the internet. In the OCI Console, the DKIM and Domain status should eventually say "Active" or "Verified".

---

## Phase 3: Update Your Spring Boot App on Oracle Cloud

If running as a Systemd Service (Recommended for Production):

1. Connect to your Oracle VM via SSH:
   ```bash
   ssh ubuntu@<your-oracle-ip>
   ```
2. Edit your systemd service file:
   ```bash
   sudo nano /etc/systemd/system/tasos.service
   ```
3. Add the `Environment` variables securely under the `[Service]` block using your OCI credentials:
   ```ini
   [Service]
   User=ubuntu
   ExecStart=/usr/bin/java -jar /home/ubuntu/tasos/target/tasos-0.0.1-SNAPSHOT.jar
   SuccessExitStatus=143
   
   # Oracle OCI Email Delivery Credentials:
   Environment="SMTP_HOST=<your_oci_smtp_endpoint>" # e.g., smtp.email.eu-frankfurt-1.oci.oraclecloud.com
   Environment="SMTP_PORT=587"
   Environment="SMTP_USERNAME=<your_generated_oci_smtp_username>"
   Environment="SMTP_PASSWORD=<your_generated_oci_smtp_password>"
   ```
4. Reload systemd and restart your application:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart tasos
   sudo systemctl status tasos
   ```

---

## Phase 4: Test the Flow
1. Open your browser and navigate to `https://leaflogic.xyz/admin-email`.
2. Fill in the "To" email, Subject, and Message.
3. Ensure the "From" field matches the exact "Approved Sender" you created in Phase 1 (e.g., `admin@leaflogic.xyz`).
4. Click Send.
5. Check your inbox (or spam folder) for the test email!

## Troubleshooting
* **Authentication Failed:** Double-check that you used the **generated SMTP credentials** from the IAM user page, *not* your Oracle Cloud login password.
* **Sender Not Approved:** Ensure the exact email address you type in the "From" field in the Spring Boot app is added to the "Approved Senders" list in the OCI dashboard.
