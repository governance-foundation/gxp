Param(
    [string]$SERVICES = "$( (Get-Content ".\start-services.conf") -join " -f ")"
)


docker-compose --env-file .env -f docker-compose.yml -f $SERVICES down
