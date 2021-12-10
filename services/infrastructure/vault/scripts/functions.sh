
#printSectionInLineReset
function printSectionInLineReset {
    printSectionLine "" ""
}

#printLineMajor
function printLineMajor {
  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  #  printf '=%.0s' {1..100}
  printf %100s | tr " " "="
  printf "\n"
}

#printLineMinor
function printLineMinor {
  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  #  echo " $(printf '\x2D%.0s' {1..98})"
  printf "_%100s" | tr " " "\x2D" | tr "_" " "
  printf "\n"
}

#printLineMinorEnd
function printLineMinorEnd {
  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  #  echo " $(printf '^%.0s' {1..98})"
   printf "_%100s" | tr " " "^" | tr "_" " "
   printf "\n"
}

#printLineMajorEnd
function printLineMajorEnd {
  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  #  printf '^%.0s' {1..100}
   printf %100s |tr " " "^"
   printf "\n"
}


#printSectionBanner(text)
function printSectionBanner {

  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  TEXT=$1
  # echo "$(printf '@%.0s' {1..100})"
  # echo "$(printf '@  %-94s  @' "$TEXT")"
  # echo "$(printf '@%.0s' {1..100})"
  printf "\n"
  printf %100s | tr " " "@"
  printf "\n"
  printf '@  %-94s  @' "$TEXT"
  printf "\n"
  printf %100s | tr " " "@"
  printf "\n"
}


#printSectionStart(text)
function printSectionStart {
  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  DEFAULT_PREFIX=""
  SECTION_TITLE=${1:-SECTION}

  LINE_TEXT="${DEFAULT_PREFIX} START: ${SECTION_TITLE}"

  printf "\n"
  printLineMajor
  printf "||%-96s||\n" "$LINE_TEXT"
  printLineMajor
}

#printSectionEnd(text)
function printSectionEnd {
  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  DEFAULT_PREFIX=""
  SECTION_TITLE=${1:-SECTION}

  LINE_TEXT="${DEFAULT_PREFIX} END: ${SECTION_TITLE}"

  printf "\n"
  printLineMajorEnd
  printf "||%-96s||\n" "$LINE_TEXT"
  printLineMajor
}

#printSubSectionStart(text)
function printSubSectionStart {
  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  DEFAULT_PREFIX=" "
  SECTION_TITLE=${1:-SECTION}

  LINE_TEXT="${DEFAULT_PREFIX} START: ${SECTION_TITLE}"

  printf "\n"
  printLineMinor
  printf " |%-96s|\n" "$LINE_TEXT"
  printLineMinor

}

function debug {
  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  echo "$1"
}

#printSubSectionEnd(text)
function printSubSectionEnd {
  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  DEFAULT_PREFIX=" "
  SECTION_TITLE=${1:-SECTION}

  LINE_TEXT="${DEFAULT_PREFIX} END: ${SECTION_TITLE}"
  printLineMinorEnd
  printf " |%-96s|\n" "$LINE_TEXT"
  printLineMinor
  printf "\n"
}

#printSectionLine(text)
function printSectionLine {
  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  DEFAULT_PREFIX=" - "
  LINE_TEXT="${1:-}"

  LINE_PREFIX=""

  if [ $# -ne 2 ]; then
      LINE_PREFIX="$DEFAULT_PREFIX"
  else
      LINE_PREFIX="$2"
  fi

  LINE_TEXT="$LINE_PREFIX$LINE_TEXT"
  printf "%s\n" "$LINE_TEXT" | fold -sw 98
}

#printSectionInLine(text)
function printSectionInLine {
  #quick exit
  if [[ $DEBUG != "true" ]]; then
    return 1
  fi

  DEFAULT_PREFIX="  > "
  LINE_TEXT="${1:-}"

  LINE_PREFIX=""

  if [ $# -ne 2 ]; then
      LINE_PREFIX="$DEFAULT_PREFIX"
  else
      LINE_PREFIX="$2"
  fi

  echo -n "$LINE_PREFIX$LINE_TEXT"
}
