Param(
  [string]$LOG_PATH = "..\..\..\logs",
  [string]$LOG_PEFIX = "vault-unseal",
  [string]$LOG_SUFFIX = ".log",
  [string]$COMMAND = "keybase whoami",
  [string]$FUNCTIONS_URI = "https://github.com/aem-design/aemdesign-docker/releases/latest/download/functions.ps1",
  [string]$DEFAULT_ROOT_TOKEN = "rostebossapp",
  [string]$DEFAULT_KEYS = "rostebossapp",
  [string]$VAULT_KEY_SHARES = 1,
  [string]$VAULT_KEY_THRESHOLD = 1,
  [Parameter(Position=0)]
  [string]$ROOT_TOKEN = "$( keybase whoami )",
  [Parameter(Position=1)]
  [string]$KEYS = "$( keybase whoami )"
)



$SKIP_CONFIG = $true
$PARENT_PROJECT_PATH = "."

. ([Scriptblock]::Create((([System.Text.Encoding]::ASCII).getString((Invoke-WebRequest -Uri "${FUNCTIONS_URI}").Content))))

#set defaults
if ( [string]::IsNullOrEmpty(${ROOT_TOKEN}) ) {
  $ROOT_TOKEN = $DEFAULT_ROOT_TOKEN
}

if ( [string]::IsNullOrEmpty(${KEYS}) ) {
  $KEYS = $DEFAULT_KEYS
}

printSectionBanner "Initialising Vault with variables"

printSectionLine "ROOT_TOKEN: $ROOT_TOKEN"
printSectionLine "KEYS: $KEYS"
printSectionLine "SHARES: $VAULT_KEY_SHARES"
printSectionLine "THRESHOLD: $VAULT_KEY_THRESHOLD"

$Env:VAULT_ROOT_TOKEN_PGP_KEY = "keybase:$ROOT_TOKEN"
$Env:VAULT_PGP_KEYS = "keybase:$KEYS"
$Env:VAULT_KEY_SHARES = "$VAULT_KEY_SHARES"
$Env:VAULT_KEY_THRESHOLD = "$VAULT_KEY_THRESHOLD"

docker-compose up vaultinit
