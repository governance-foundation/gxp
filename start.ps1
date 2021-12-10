Param(
  [string]$FUNCTIONS_URI = "https://github.com/aem-design/aemdesign-docker/releases/latest/download/functions.ps1",
  [string]$SERVICES = "$( (Get-Content ".\start-services.conf") -join " -f ")"
)

$SKIP_CONFIG = $true
$PARENT_PROJECT_PATH = ".."

. ([Scriptblock]::Create((([System.Text.Encoding]::ASCII).getString((Invoke-WebRequest -Uri "${FUNCTIONS_URI}").Content))))

$DOCKER_COMMAND="docker-compose --env-file .env -f docker-compose.yml -f ${SERVICES} up"

printSectionLine "${DOCKER_COMMAND}"


printSubSectionStart "Docker Compose Execute"

Invoke-Expression "${DOCKER_COMMAND}"


