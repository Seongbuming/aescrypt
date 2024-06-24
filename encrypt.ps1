# Input the path of the directory to encrypt
$relativePath = Read-Host "Enter the relative path of the directory to encrypt"
try {
    $targetDir = Resolve-Path -Path $relativePath -ErrorAction Stop
} catch {
    Write-Host "Error: The specified path does not exist." -ForegroundColor Red
    exit
}

# Input the password for encryption
$password = Read-Host "Enter the password for encryption" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Search and encrypt files
Get-ChildItem -Path $targetDir -Recurse -File | Where-Object { $_.Extension -ne ".aes" } | ForEach-Object {
    $file = $_.FullName
    Write-Host "Encrypting: $file"

    $outputFile = "$file.aes"
    Start-Process -FilePath "C:\Program Files\AESCrypt\AESCrypt.exe" -ArgumentList "-e", "-p", "`"$PlainPassword`"", "`"$file`"" -NoNewWindow -Wait

    if (Test-Path -Path $outputFile) {
        Remove-Item -Path $file -Force
        Write-Host "Original file deleted: $file"
    } else {
        Write-Host "Encryption failed for: $file" -ForegroundColor Red
    }
}

Write-Host "Encryption complete. Press Enter to exit..."
Read-Hosts
