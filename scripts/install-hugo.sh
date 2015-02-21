#!/bin/bash

VERSION="0.12"
URL="https://github.com/spf13/hugo/releases/download/v{{VER}}/hugo_{{VER}}_{{OS}}_{{HW}}.{{EXT}}"

##

set -eu

BASE="$(cd "$(dirname $0)"; pwd)"
HUGO="$BASE/../hugo"

main() {
    local os ext expand
    case "$(uname -s)" in
        Linux)
            os=linux
            ext=tar.gz
            expand="tar -zx --wildcards */hugo* -O"
            ;;
        Darwin)
            os=darwin
            ext=zip
            expand="unzip -qc - '*/hugo*'"
            ;;
        *) abort "Unknown OS: $(uname -s)" ;;
    esac

    local hw
    case "$(uname -m)" in
        x86_64) hw=amd64 ;;
        *) abort "Unknown machine hardware name: $(uname -m)" ;;
    esac

    local url="$URL"
    url=$(sed "s/{{VER}}/$VERSION/g" <<< "$url")
    url=$(sed "s/{{OS}}/$os/g" <<< "$url")
    url=$(sed "s/{{EXT}}/$ext/g" <<< "$url")
    url=$(sed "s/{{HW}}/$hw/g" <<< "$url")

    echo "---------------------"
    echo "OS:  $os"
    echo "Ext: $ext"
    echo "Hw:  $hw"
    echo "URL: $url"
    echo "---------------------"
    echo

    echo $ curl -L \$url '|' $expand '>' "$HUGO"
    curl -L "$url" | $expand > "$HUGO"

    echo $ chmod +x "$HUGO"
    chmod +x "$HUGO"
}

abort() {
    echo "$@" >&2
    exit 1
}

main
