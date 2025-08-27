# Generate Flowndly Security Keys
Write-Host "Generating Flowndly Security Keys..." -ForegroundColor Green

# Generate random base64 strings
$encryptionKey = [Convert]::ToBase64String((1..36 | ForEach-Object { Get-Random -Maximum 256 }))
$webhookSecretKey = [Convert]::ToBase64String((1..36 | ForEach-Object { Get-Random -Maximum 256 }))
$appSecretKey = [Convert]::ToBase64String((1..36 | ForEach-Object { Get-Random -Maximum 256 }))
$postgresPassword = [Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))

Write-Host "`nGenerated Security Keys:" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Yellow

Write-Host "`nENCRYPTION_KEY:" -ForegroundColor Cyan
Write-Host $encryptionKey -ForegroundColor White

Write-Host "`nWEBHOOK_SECRET_KEY:" -ForegroundColor Cyan
Write-Host $webhookSecretKey -ForegroundColor White

Write-Host "`nAPP_SECRET_KEY:" -ForegroundColor Cyan
Write-Host $appSecretKey -ForegroundColor White

Write-Host "`nPOSTGRES_PASSWORD:" -ForegroundColor Cyan
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

# IMPORTANT: Update HOST with your actual domain before deployment
# IMPORTANT: Change default passwords after first login
"@

$envContent | Out-File -FilePath ".env" -Encoding UTF8

Write-Host "`n.env file created successfully!" -ForegroundColor Green
Write-Host "Please update HOST with your actual domain name" -ForegroundColor Yellow
