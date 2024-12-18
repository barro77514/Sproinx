# Decryptor Tool for Files Encrypted by Sproinx Ransomware
# This script assumes you have the recovery key (PSRKey) needed to decrypt the files.

param (
    [string]$Key,  # Recovery key for decryption
    [string]$Directory  # Directory containing encrypted files
)

# Function to perform AES decryption
function Invoke-AESEncryption {
    [CmdletBinding()]
    [OutputType([string])]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Encrypt", "Decrypt")]
        [String]$Mode,

        [Parameter(Mandatory = $true)]
        [String]$Key,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptFile")]
        [String]$Path
    )

    Begin {
        $shaManaged = New-Object System.Security.Cryptography.SHA256Managed
        $aesManaged = New-Object System.Security.Cryptography.AesManaged
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
    }

    Process {
        $aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Key))
        
        switch ($Mode) {
            "Decrypt" {
                $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                if (!$File.FullName) { return }

                $cipherBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                $aesManaged.IV = $cipherBytes[0..15]
                $decryptor = $aesManaged.CreateDecryptor()

                $decryptedBytes = $decryptor.TransformFinalBlock($cipherBytes, 16, $cipherBytes.Length - 16)
                $outPath = $File.FullName.replace(".psr", "")

                [System.IO.File]::WriteAllBytes($outPath, $decryptedBytes)
                (Get-Item $outPath).LastWriteTime = $File.LastWriteTime

                Write-Host "[+] Decrypted: $outPath" -ForegroundColor Green

                # Remove the original .psr file
                Remove-Item -Path $File.FullName -Force
                Write-Host "[+] Removed: $File.FullName" -ForegroundColor Yellow
            }
        }
    }

    End {
        $shaManaged.Dispose()
        $aesManaged.Dispose()
    }
}

# Main Decryption Process
if (-not (Test-Path $Directory)) {
    Write-Host "[!] Directory does not exist: $Directory" -ForegroundColor Red
    exit
}

$encryptedFiles = Get-ChildItem -Path $Directory -Recurse -Filter "*.psr" | Where-Object { -not $_.PSIsContainer }

if (-not $encryptedFiles) {
    Write-Host "[!] No encrypted files found in directory: $Directory" -ForegroundColor Yellow
    exit
}

foreach ($file in $encryptedFiles) {
    Invoke-AESEncryption -Mode Decrypt -Key $Key -Path $file.FullName
}

Write-Host "[i] Decryption complete." -ForegroundColor Cyan
