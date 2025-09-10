<powershell>
# Create DSL directory
New-Item -Path "C:\DSL" -ItemType Directory -Force

# Create test files
1..100 | ForEach-Object {
    $content = "Test file $_" * 100
    Set-Content -Path "C:\DSL\file$_.txt" -Value $content
}

# Create some fake certificates
1..10 | ForEach-Object {
    Set-Content -Path "C:\DSL\cert$_.pem" -Value "FAKE CERT"
}

# Create SMB share
New-SmbShare -Name "DSL$" -Path "C:\DSL" -FullAccess "Everyone"

# Create service account
$password = ConvertTo-SecureString "DataSync123!" -AsPlainText -Force
New-LocalUser -Name "datasync" -Password $password -PasswordNeverExpires
</powershell>