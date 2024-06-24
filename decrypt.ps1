# Input the path of the directory to decrypt
$relativePath = Read-Host "Enter the relative path of the directory to decrypt"
try {
    $targetDir = Resolve-Path -Path $relativePath -ErrorAction Stop
} catch {
    Write-Host "Error: The specified path does not exist." -ForegroundColor Red
    exit
}

# Input the password for decryption
$password = Read-Host "Enter the password for decryption" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Search and decrypt files
Get-ChildItem -Path $targetDir -Recurse -File | Where-Object { $_.Extension -eq ".aes" } | ForEach-Object {
    $file = $_.FullName
    Write-Host "Decrypting: $file"

    $outputFile = $file -replace ".aes$",""
    Start-Process -FilePath "C:\Program Files\AESCrypt\AESCrypt.exe" -ArgumentList "-d", "-p", "`"$PlainPassword`"", "`"$file`"" -NoNewWindow -Wait

    if (Test-Path -Path $outputFile) {
        Remove-Item -Path $file -Force
        Write-Host "Encrypted file deleted: $file"
    } else {
        Write-Host "Decryption failed for: $file" -ForegroundColor Red
    }
}

Write-Host "Decryption complete. Press Enter to exit..."
Read-Host
