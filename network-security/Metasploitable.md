# Metasploitable2 Vulnerability Assessment Report

## Project Overview
This report documents 10 distinct vulnerabilities discovered on a private target machine (Metasploitable2) from an isolated virtual attacker environment (Kali Linux).

## Recon Summary
The network discovery phase mapped open entry pathways into the target machine infrastructure.
![Reconnaissance Scan Output](evidence/recon.png)

## Vulnerability Analysis Matrix

### 1. VSFTPD Backdoor Execution (Port 21)
* **Vulnerability Type:** Software Backdoor / Malicious Code Injection
* **Cyber Kill Chain Phase:** Exploitation / Installation
* **Description:** Accessing a hidden backdoor built into the file transfer service.
![Exploit 1 Evidence](evidence/exploit1.png)

### 2. Samba usermap_script Command Injection (Port 139/445)
* **Vulnerability Type:** Remote Code Execution (RCE)
* **Cyber Kill Chain Phase:** Exploitation
* **Description:** Injecting administrative system commands into file-sharing authentication fields.
![Exploit 2 Evidence](evidence/exploit2.png)

### 3. UnrealIRCd Backdoor (Port 6667)
* **Vulnerability Type:** Malicious Modification / Code Execution
* **Cyber Kill Chain Phase:** Weaponization / Delivery
* **Description:** Activating a hidden application trigger via remote service connections.
![Exploit 3 Evidence](evidence/exploit3.png)

### 4. PHP CGI Argument Injection (Port 80)
* **Vulnerability Type:** Web Application Parameter Flaw
* **Cyber Kill Chain Phase:** Exploitation
* **Description:** Forcing the web server to run local system binaries by breaking request parameters.
![Exploit 4 Evidence](evidence/exploit4.png)

### 5. Telnet Weak Authentication (Port 23)
* **Vulnerability Type:** Default Credentials & Unencrypted Protocol
* **Cyber Kill Chain Phase:** Actions on Objectives
* **Description:** Accessing system management features using default system administrator logins over cleartext.
![Exploit 5 Evidence](evidence/exploit5.png)

### 6. SSH Open Protocol / Weak Credentials (Port 22)
* **Vulnerability Type:** Administrative Account Exposure
* **Cyber Kill Chain Phase:** Actions on Objectives
* **Description:** Remotely logging straight into terminal services due to predictable administrative pairings.
![Exploit 6 Evidence](evidence/exploit6.png)

### 7. Anonymous FTP Access (Port 21)
* **Vulnerability Type:** Access Control Misconfiguration
* **Cyber Kill Chain Phase:** Reconnaissance / Delivery
* **Description:** Reviewing server configurations without establishing proper validation.
![Exploit 7 Evidence](evidence/exploit7.png)

### 8. VNC Plaintext Weak Password (Port 5900)
* **Vulnerability Type:** Predictable Desktop Authentication
* **Cyber Kill Chain Phase:** Exploitation
* **Description:** Identifying administrative access combinations guarding graphical user interfaces.
![Exploit 8 Evidence](evidence/exploit8.png)

### 9. MySQL Administrative Blank Password (Port 3306)
* **Vulnerability Type:** Database Service Exposure
* **Cyber Kill Chain Phase:** Exploitation
* **Description:** Connecting as the primary database administrator using empty authentication arrays.
![Exploit 9 Evidence](evidence/exploit9.png)

### 10. Samba Share Access Enumeration (Port 139/445)
* **Vulnerability Type:** Information Disclosure / Null Session
* **Cyber Kill Chain Phase:** Reconnaissance
* **Description:** Querying explicit internal environment directories without requiring administrative rights.
![Exploit 10 Evidence](evidence/exploit10.png)

## Kill Chain Coverage Summary

| Exploit # | Target Vector | Cyber Kill Chain Mapping | Max Privilege Attained |
|-----------|---------------|--------------------------|------------------------|
| 1         | FTP           | Exploitation             | root                   |
| 2         | Samba         | Exploitation             | root                   |
| 3         | IRC           | Delivery                 | root                   |
| 4         | HTTP (PHP)    | Exploitation             | www-data               |
| 5         | Telnet        | Actions on Objectives    | msfadmin               |
| 6         | SSH           | Actions on Objectives    | msfadmin               |
| 7         | FTP (Anon)    | Reconnaissance           | anonymous              |
| 8         | VNC           | Exploitation             | administrator          |
| 9         | MySQL         | Exploitation             | root database          |
| 10        | SMB Enum      | Reconnaissance           | guest                  |
