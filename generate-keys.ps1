# Generate Flowndly Security Keys
Write-Host "🔐 Generating Flowndly Security Keys..." -ForegroundColor Green

# Function to generate random base64 string
function Generate-RandomBase64 {
    param([int]$Length = 36)
    $bytes = New-Object Byte[] $Length
    (New-Object Security.Cryptography.RNGCryptoServiceProvider).GetBytes($bytes)
    return [Convert]::ToBase64String($bytes)
}

# Generate the three required keys
$encryptionKey = Generate-RandomBase64 36
$webhookSecretKey = Generate-RandomBase64 36
$appSecretKey = Generate-RandomBase64 36
$postgresPassword = Generate-RandomBase64 32

Write-Host "`n✅ Generated Security Keys:" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Yellow

Write-Host "`n🔑 ENCRYPTION_KEY:" -ForegroundColor Cyan
Write-Host $encryptionKey -ForegroundColor White

Write-Host "`n🔑 WEBHOOK_SECRET_KEY:" -ForegroundColor Cyan
Write-Host $webhookSecretKey -ForegroundColor White

Write-Host "`n🔑 APP_SECRET_KEY:" -ForegroundColor Cyan
Write-Host $appSecretKey -ForegroundColor White

Write-Host "`n🔑 POSTGRES_PASSWORD:" -ForegroundColor Cyan
Write-Host $postgresPassword -ForegroundColor White

# Create .env file
$envContent = @"
# Flowndly Production Environment Variables
# Generated on $(Get-Date)

# Required Security Keys
ENCRYPTION_KEY=$encryptionKey
WEBHOOK_SECRET_KEY=$webhookSecretKey
APP_SECRET_KEY=$appSecretKey
POSTGRES_PASSWORD=$postgresPassword

# Application Settings
HOST=localhost
PROTOCOL=https
APP_ENV=production
APP_TITLE=Flowndly
TELEMETRY_ENABLED=false

# Database Settings
POSTGRES_DATABASE=automatisch
POSTGRES_USERNAME=automatisch_user
POSTGRES_ENABLE_SSL=false

# Logging
LOG_LEVEL=info

# ⚠️  IMPORTANT: Update HOST with your actual domain before deployment
# ⚠️  IMPORTANT: Change default passwords after first login
"@

$envContent | Out-File -FilePath ".env" -Encoding UTF8

Write-Host "`n📄 .env file created successfully!" -ForegroundColor Green
Write-Host "⚠️  Please update HOST with your actual domain name" -ForegroundColor Yellow
