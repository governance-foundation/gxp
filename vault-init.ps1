Param(
  [Parameter(Position=0)]
  [string]$TOKEN = "$( keybase whoami )",
  [Parameter(Position=1)]
  [string]$KEYS = "$( keybase whoami )"
)

.\docker\vault\scripts\init.ps1 $TOKEN $KEYS

