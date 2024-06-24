#!/bin/bash

# Input the path of the directory to decrypt
read -p "Enter the relative path of the directory to decrypt: " relativePath
if [ ! -d "$relativePath" ]; then
    echo "Error: The specified path does not exist."
    exit 1
fi

# Input the password for decryption
read -sp "Enter the password for decryption: " password
echo

# Search and decrypt files
find "$relativePath" -type f -name "*.aes" | while read -r file; do
    echo "Decrypting: $file"
    
    outputFile="${file%.aes}"
    if aescrypt -d -p "$password" -o "$outputFile" "$file"; then
        rm -f "$file"
        echo "Encrypted file deleted: $file"
    else
        echo "Decryption failed for: $file"
    fi
done

echo "Decryption complete."
