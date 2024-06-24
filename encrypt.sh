#!/bin/bash

# Input the path of the directory to encrypt
read -p "Enter the relative path of the directory to encrypt: " relativePath
if [ ! -d "$relativePath" ]; then
    echo "Error: The specified path does not exist."
    exit 1
fi

# Input the password for encryption
read -sp "Enter the password for encryption: " password
echo

# Search and encrypt files
find "$relativePath" -type f ! -name "*.aes" | while read -r file; do
    echo "Encrypting: $file"
    
    outputFile="$file.aes"
    if aescrypt -e -p "$password" -o "$outputFile" "$file"; then
        rm -f "$file"
        echo "Original file deleted: $file"
    else
        echo "Encryption failed for: $file"
    fi
done

echo "Encryption complete."
