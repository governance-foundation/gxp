#!/bin/busybox sh

#import utils
. /scripts/functions.sh

DEFAULT_VAULT_ADDR="http://vault:8200"
DEFAULT_WEBHOOK_URL="https://bots.keybase.io/webhookbot/6KzrLGeSZtRhgG5T2DRa5FMjATM"
DEFAULT_VAULT_ROOT_TOKEN_PGP_KEY="keybase:rosterbossapp"
DEFAULT_VAULT_KEY_SHARES="1" #3
DEFAULT_VAULT_KEY_THRESHOLD="1" #2
DEFAULT_VAULT_PGP_KEYS="keybase:rosterbossapp"
DEFAULT_FILE_OUTPUT_PATH="/data/"
DEFAULT_FILE_OUTPUT_EXT_TOKEN=".token"
DEFAULT_FILE_OUTPUT_EXT_KEY=".key"
# DEFAULT_VAULT_PGP_KEYS="keybase:maxbarrass,keybase:kenbkop,keybase:rosterbossapp"
DEBUG=true
DEBUG_OUTPUT="vault.txt"

if [[ ! $DEBUG ]]; then
  if [[ "${VAULT_ROOT_TOKEN_PGP_KEY}" == "" || "${VAULT_KEY_SHARES}"  == "" || "${VAULT_KEY_THRESHOLD}" == "" || "${VAULT_PGP_KEYS}" == "" ]]; then
    echo "Please specify parameters"
    echo " - VAULT_ROOT_TOKEN_PGP_KEY"
    echo " - VAULT_KEY_SHARES"
    echo " - VAULT_KEY_THRESHOLD"
    echo " - VAULT_PGP_KEYS"
    echo " - WEBHOOK_URL"
    exit 1 ## FAILED
  fi
fi

printSectionBanner "VAULT INIT"

# send messages here
WEBHOOK_URL=${WEBHOOK_URL:-$DEFAULT_WEBHOOK_URL}
WEBHOOK_COMMAND="curl -H 'Accept: application/json' -d '\"message\":\"test\"' -X POST ${WEBHOOK_URL}"

# use this to init the vault
VAULT_ROOT_TOKEN_PGP_KEY=${VAULT_ROOT_TOKEN_PGP_KEY:-$DEFAULT_VAULT_ROOT_TOKEN_PGP_KEY}
VAULT_KEY_SHARES=${VAULT_KEY_SHARES:-$DEFAULT_VAULT_KEY_SHARES}
VAULT_KEY_THRESHOLD=${VAULT_KEY_THRESHOLD:-$DEFAULT_VAULT_KEY_THRESHOLD}
VAULT_PGP_KEYS=${VAULT_PGP_KEYS:-$DEFAULT_VAULT_PGP_KEYS}

# use these to save files
FILE_OUTPUT_PATH=${FILE_OUTPUT_PATH:-$DEFAULT_FILE_OUTPUT_PATH}
FILE_OUTPUT_EXT_KEY=${FILE_OUTPUT_EXT_KEY:-$DEFAULT_FILE_OUTPUT_EXT_KEY}
FILE_OUTPUT_EXT_TOKEN=${FILE_OUTPUT_EXT_TOKEN:-$DEFAULT_FILE_OUTPUT_EXT_TOKEN}

# tell vault cli which vault to talk to
export VAULT_ADDR=${VAULT_ADDR:-$DEFAULT_VAULT_ADDR}


printSectionLine "WEBHOOK_COMMAND: ${WEBHOOK_COMMAND}"
printSectionLine "VAULT_ROOT_TOKEN_PGP_KEY: ${VAULT_ROOT_TOKEN_PGP_KEY}"
printSectionLine "VAULT_KEY_SHARES: ${VAULT_KEY_SHARES}"
printSectionLine "VAULT_KEY_THRESHOLD: ${VAULT_KEY_THRESHOLD}"
printSectionLine "VAULT_PGP_KEYS: ${VAULT_PGP_KEYS}"
printSectionLine "VAULT_ADDR: ${VAULT_ADDR}"
printSectionLine "FILE_OUTPUT_PATH: ${FILE_OUTPUT_PATH}"
printSectionLine "FILE_OUTPUT_EXT_KEY: ${FILE_OUTPUT_EXT_KEY}"
printSectionLine "FILE_OUTPUT_EXT_TOKEN: ${FILE_OUTPUT_EXT_TOKEN}"


# commands for vault init
COMMAND_VAULT_INIT="vault operator init -key-shares=$VAULT_KEY_SHARES -key-threshold=$VAULT_KEY_THRESHOLD -pgp-keys=$VAULT_PGP_KEYS -root-token-pgp-key=$VAULT_ROOT_TOKEN_PGP_KEY"
COMMAND_VAULT_STATUS="vault status"

# text output checks
CHECK_TOKEN="Unseal Key"
CHECK_ROOT_TOKEN="Initial Root Token"
CHECK_INIT="* Vault is already initialized"
CHECK_STATUS_INIT="Initialized"
CHECK_STATUS_SEALED="Sealed"


printSectionStart "Vault Current Status"

# check vault status
RESULT_VAULT_STATUS="$(${COMMAND_VAULT_STATUS})"

debug "$RESULT_VAULT_STATUS"

VAULT_SEALED=$(echo "$RESULT_VAULT_STATUS" | grep ${CHECK_STATUS_SEALED} | awk '{ print $NF }')
VAULT_INIT=$(echo "$RESULT_VAULT_STATUS" | grep ${CHECK_STATUS_INIT} | awk '{ print $NF }')

printLineMajorEnd

printSectionLine "VAULT_SEALED: ${VAULT_SEALED}"
printSectionLine "VAULT_INIT: ${VAULT_INIT}"

VAULT_INIT_OUTPUT=""

# Initialise Vault
if [[ "${VAULT_INIT}" == "false" ]]; then

  printSectionStart "Initialise Vault"

  printSectionLine "Initialising Vault"
  printSectionLine "${COMMAND_VAULT_INIT}"

  VAULT_INIT_OUTPUT="$(${COMMAND_VAULT_INIT})"
  if [[ $DEBUG ]]; then
    echo "$VAULT_INIT_OUTPUT">${DEBUG_OUTPUT}
  fi
else
  printSectionStart "Vault Alteady Initialised"
fi

if [[ $DEBUG ]]; then
  printSectionLine "Using ${DEBUG_OUTPUT} as source of init data."
  VAULT_INIT_OUTPUT="`cat ${DEBUG_OUTPUT}`"
  if [[ "$VAULT_INIT_OUTPUT" == "" ]]; then
    debug "Could not located debug output file ${DEBUG_OUTPUT}."
    exit 1
  fi
fi

printLineMajorEnd

VAULT_INIT_KEYS=`echo "${VAULT_INIT_OUTPUT}" | grep -e "${CHECK_TOKEN}" | awk -F': ' '{print $NF}'`

KEY_INDEX=1

for i in $(echo "$VAULT_INIT_KEYS")
do
  COMMAND="echo \"$DEFAULT_VAULT_PGP_KEYS\" | awk -F',' '{ gsub(\":\",\"/\",\$$KEY_INDEX); print \$$KEY_INDEX}'"

  KEY_INDEX=$((KEY_INDEX+1))
  FILE_NAME="${FILE_OUTPUT_PATH}$(eval $COMMAND)${FILE_OUTPUT_EXT_KEY}"
  mkdir -p "${FILE_NAME%/*}"
  echo -n ${i}>${FILE_NAME}
  printSectionLine "${FILE_NAME}"
done

VAULT_ROOT_KEY=`echo "${VAULT_INIT_OUTPUT}" | grep -e "${CHECK_ROOT_TOKEN}" | awk -F': ' '{ print $NF}'`
FILE_NAME=${FILE_OUTPUT_PATH}${VAULT_ROOT_TOKEN_PGP_KEY/:/\/}${FILE_OUTPUT_EXT_TOKEN}
mkdir -p "${FILE_NAME%/*}"
echo -n ${VAULT_ROOT_KEY}>${FILE_NAME}
printSectionLine "${FILE_NAME}"

printSectionStart "Vault Outcome Status"

RESULT_VAULT_STATUS="$(${COMMAND_VAULT_STATUS})"

debug "$RESULT_VAULT_STATUS"



# if [[  "${RESULT}" != "" ]]; then
#   echo "SUCCESS"
#   exit 0 ## SUCCESS
# else
#   echo "FAILED"
#   exit 1 ## FAILED
# fi
