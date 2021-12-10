Param(
  [string]$LOG_PATH = "..\..\..\logs",
  [string]$LOG_PEFIX = "vault-unseal",
  [string]$LOG_SUFFIX = ".log",
  [string]$COMMAND = "keybase pgp decrypt -i DECRYPTFILE",
  [string]$FUNCTIONS_URI = "https://github.com/aem-design/aemdesign-docker/releases/latest/download/functions.ps1",
  [string]$DEFAULT_ROOT_TOKEN = "rostebossapp",
  [string]$DEFAULT_KEYS = "rostebossapp",
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

printSectionBanner "Getting Encrypted Vault Kays"

$KEYB64 = "$( Get-Content ".\data\vault\keybase\$NAME.key" -Raw)"
$TOKENB64 = "$( Get-Content ".\data\vault\keybase\$ROOT_TOKEN.token" -Raw)"

$KEYB = [Convert]::FromBase64String($KEYB64)
$KEYB64B_FILE = ".\data\vault\keybase\$NAME.key.bin"
Set-Content -Path $KEYB64B_FILE -AsByteStream -Value $KEYB
#printSectionLine $KEYB64B_FILE

$TOKENB64B = [Convert]::FromBase64String($TOKENB64)
$TOKENB64B_FILE = ".\data\vault\keybase\$ROOT_TOKEN.token.bin"
Set-Content -Path $TOKENB64B_FILE -AsByteStream -Value $TOKENB64B
#printSectionLine $TOKENB64B_FILE

$KEY_COMMAND = ("$COMMAND" -replace "DECRYPTFILE", "$KEYB64B_FILE")
#printSectionLine $KEY_COMMAND

printSectionBanner "Using Keybase to decrypt Keys, watch for Keybase prompts."

$Env:VAULT_KEY = (Invoke-Expression -Command "$KEY_COMMAND")

$TOKEN_COMMAND = ("$COMMAND" -replace "DECRYPTFILE", "$TOKENB64B_FILE")
#printSectionLine $TOKEN_COMMAND

$Env:VAULT_TOKEN = (Invoke-Expression -Command "$TOKEN_COMMAND")

printSectionBanner "Unsealing Vault"

docker-compose up vaultunseal

printSectionBanner "VAULT LOGIN TOKEN"
printSectionLine "TOKEN = $Env:VAULT_TOKEN"

$Env:VAULT_TOKEN = ""
$Env:VAULT_KEY = ""
