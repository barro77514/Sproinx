# AES Decryption Function for AES-192
Function Decrypt-AES {
    param (
        [string]$encryptedFile,   # Path to the encrypted file
        [string]$decryptionKey,   # Decryption key (192-bit key for AES-192)
        [string]$outputFile       # Path where the decrypted file will be saved
    )
    
    # Check if the key length is valid (192 bits -> 24 bytes)
    if ($decryptionKey.Length -ne 24) {
        Write-Host "Error: The decryption key must be 192 bits (24 bytes)."
        return
    }
    
    # Create AES object
    $aes = [System.Security.Cryptography.AesManaged]::new()
    $aes.Key = [System.Text.Encoding]::UTF8.GetBytes($decryptionKey)  # AES-192 uses a 24-byte key
    $aes.IV = [byte[]](0..15)  # Initialize the IV to all zeros (replace with correct IV if needed)
    
    # Create a decryptor
    $decryptor = $aes.CreateDecryptor()

    # Read the encrypted file as bytes
    $encryptedData = [System.IO.File]::ReadAllBytes($encryptedFile)
    
    # Perform the decryption
    try {
        $decryptedData = $decryptor.TransformFinalBlock($encryptedData, 0, $encryptedData.Length)
        
        # Write the decrypted data to the output file
        [System.IO.File]::WriteAllBytes($outputFile, $decryptedData)
        
        Write-Host "File decrypted successfully and saved to $outputFile"
    } catch {
        Write-Host "Error: Decryption failed. Ensure the decryption key and IV are correct."
    }
}

