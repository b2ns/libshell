#!/usr/bin/env bash
import String

declare -gA LIBSHELL_COLOR_CODES=(
  [black]="30 39"
  [red]="31 39"
  [green]="32 39"
  [yellow]="33 39"
  [blue]="34 39"
  [magenta]="35 39"
  [cyan]="36 39"
  [white]="37 39"
  [blackBright]="90 39"
  [redBright]="91 39"
  [greenBright]="92 39"
  [yellowBright]="93 39"
  [blueBright]="94 39"
  [magentaBright]="95 39"
  [cyanBright]="96 39"
  [whiteBright]="97 39"

  [bgBlack]="40 49"
  [bgRed]="41 49"
  [bgGreen]="42 49"
  [bgYellow]="44 39"
  [bgBlue]="44 49"
  [bgMagenta]="45 49"
  [bgCyan]="46 49"
  [bgWhite]="47 49"
  [bgBlackBright]="100 49"
  [bgRedBright]="101 49"
  [bgGreenBright]="102 49"
  [bgYellowBright]="104 39"
  [bgBlueBright]="104 49"
  [bgMagentaBright]="105 49"
  [bgCyanBright]="106 49"
  [bgWhiteBright]="107 49"

  [reset]="0 0"
  [bold]="1 22"
  [dim]="2 22"
  [italic]="3 23"
  [underline]="4 24"
  [blink]="5 25"
  [overline]="53 55"
  [inverse]="7 27"
  [hidden]="8 28"
  [strikethrough]="9 29"
)

Color() {
  local -a args=("$@")
  local -i len=${#args[@]}
  local text="${1:-}"
  local codeStart=""
  local codeEnd=""
  local -i i=""

  for ((i = 1; i < len; i++)); do
    local color="${args[$i]}"
    String_isEmpty "$color" && continue
    if [[ ${LIBSHELL_COLOR_CODES[$color]+_} ]]; then
      local codes="${LIBSHELL_COLOR_CODES["$color"]}"
      String_split "$codes" " " >/dev/null
      codeStart="$codeStart;${RETVAL[0]}"
      codeEnd="$codeEnd;${RETVAL[1]}"
    elif String_match "$color" "^#[a-f0-9]{6,6}+(\|bg)?$" ||
      String_match "$color" "^#[a-f0-9]{3,3}+(\|bg)?$" ||
      String_match "$color" "^rgb *\( *[0-9]+ *, *[0-9]+ *, *[0-9]+ *\)(\|bg)?$"; then
      # "rgb(1,1,1)|bg"
      # "#fff|bg"
      # "#f0f0f0|bg"

      local bg=""
      String_stripStart "$color" "*|" 1 >/dev/null
      bg="$RETVAL"

      local tmpStart="38;2"
      local tmpEnd="39"
      if String_eq "$bg" "bg"; then
        tmpStart="48;2"
        tmpEnd="49"
      fi

      String_stripEnd "$color" "|*" 1 >/dev/null
      color="$RETVAL"

      # hex
      if String_startsWith "$color" "#"; then
        __hex2rgb__ "$color" >/dev/null
        color="$RETVAL"
      fi

      # rgb
      local -i r=0
      local -i g=0
      local -i b=0
      String_replaceAll "$color" "[rgb ()]" "" >/dev/null
      color="$RETVAL"

      String_split "$color" "," >/dev/null
      r="${RETVAL[0]}"
      g="${RETVAL[1]}"
      b="${RETVAL[2]}"

      ((r > 255)) && r=255
      ((g > 255)) && g=255
      ((b > 255)) && b=255

      codeStart="$codeStart;$tmpStart;$r;$g;$b"
      codeEnd="$codeEnd;$tmpEnd"
    fi
  done

  if String_notEmpty "$codeStart"; then
    String_stripStart "$codeStart" ";" >/dev/null
    codeStart="$RETVAL"

    String_stripStart "$codeEnd" ";" >/dev/null
    codeEnd="$RETVAL"

    # fix nest color codes
    if String_match "$text" "\\e\[([0-9;]+)m.+$"; then
      local prefix=""
      local suffix=""
      String_stripStart "$text" "*\e[*m" 1 >/dev/null
      suffix="$RETVAL"

      String_stripEnd "$text" "$suffix" >/dev/null
      prefix="$RETVAL"

      RETVAL="\e[${codeStart}m${prefix}\e[${codeStart}m${suffix}\e[${codeEnd}m"
      echo -n "\e[${codeStart}m${prefix}\e[${codeStart}m${suffix}\e[${codeEnd}m"
    else
      RETVAL="\e[${codeStart}m${text}\e[${codeEnd}m"
      echo -n "\e[${codeStart}m${text}\e[${codeEnd}m"
    fi
  else
    RETVAL="$text"
    printf "%s" "$text"
  fi
}

Color_print() {
  Color "$@" >/dev/null
  printf "$RETVAL%s" ""
}

__hex2rgb__() {
  local hex="$1"
  local -i r=""
  local -i g=""
  local -i b=""

  String_stripStart "$hex" "#" 1 >/dev/null
  hex="$RETVAL"
  local -i len=${#hex}

  String_split "$hex" "" >/dev/null
  hex=("${RETVAL[@]}")

  if ((len == 3)); then
    r=$((16#${hex[0]}${hex[0]}))
    g=$((16#${hex[1]}${hex[1]}))
    b=$((16#${hex[2]}${hex[2]}))
  else
    r=$((16#${hex[0]}${hex[1]}))
    g=$((16#${hex[2]}${hex[3]}))
    b=$((16#${hex[4]}${hex[5]}))
  fi

  RETVAL="$r,$g,$b"
  printf '%s\n' "rgb($r,$g,$b)"
}
