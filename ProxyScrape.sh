#!/usr/bin/env bash

set -e

# ColorEchoForShell
# https://github.com/PeterDaveHello/ColorEchoForShell

echo.Cyan() {
    echo -e "\\033[36m$*\\033[m"
}

echo.Red() {
    echo -e "\\033[31m$*\\033[m"
}

echo.Green() {
  echo -e "\\033[32m$*\\033[m"
}

error() {
    echo.Red >&2 "$@"
    exit 1
}

for cmd in wc curl flock mktemp mv dos2unix sort uniq xargs; do
    if ! command -v $cmd &> /dev/null; then
        error "command: $cmd not found!"
    fi
done

SOCKS5_PROXY_SOURCE=(
    "https://api.proxyscrape.com/v2/?request=getproxies&protocol=socks5&timeout=10000&country=all"
    "https://www.proxy-list.download/api/v1/get?type=socks5"
    "https://www.proxyscan.io/download?type=socks5"
    "https://raw.githubusercontent.com/TheSpeedX/SOCKS-List/master/socks5.txt"
    "https://raw.githubusercontent.com/hookzof/socks5_list/master/proxy.txt"
    "https://raw.githubusercontent.com/jetkai/proxy-list/main/online-proxies/txt/proxies.txt"
    "https://raw.githubusercontent.com/manuGMG/proxy-365/main/SOCKS5.txt"
    "https://raw.githubusercontent.com/monosans/proxy-list/main/proxies/socks5.txt"
)

if [ -z "$SOCKS5_PROXY_LIST" ]; then
    SOCKS5_PROXY_LIST="$(mktemp --suffix=-ProxyScrape.sh)"
fi

PROXY_TIMEOUT="${PROXY_TIMEOUT:-3}"
TEST_TARGET_HOST="${TEST_TARGET_HOST:-https://www.google.com}"

echo > "$SOCKS5_PROXY_LIST"
for URL in "${SOCKS5_PROXY_SOURCE[@]}"; do
    TEMP="$(mktemp --suffix=-ProxyScrape.sh)"
    if curl -sSL --fail "$URL" -o "$TEMP"; then
        echo.Green "Proxy list downloaded from $URL"
        dos2unix -q "$TEMP"
        flock "$SOCKS5_PROXY_LIST" cat "$TEMP" >> "$SOCKS5_PROXY_LIST"
        rm "$TEMP"
    fi
done

echo.Cyan "Deduplicating proxy hosts..."
SOCKS5_PROXY_LIST_COUNT_OLD="$(wc -l < "$SOCKS5_PROXY_LIST")"
sort "$SOCKS5_PROXY_LIST" | uniq | xargs -n 1 > "$TEMP"
mv "$TEMP" "$SOCKS5_PROXY_LIST"
SOCKS5_PROXY_LIST_COUNT_NEW="$(wc -l < "$SOCKS5_PROXY_LIST")"
SOCKS5_PROXY_LIST_COUNT_DIFF="$((SOCKS5_PROXY_LIST_COUNT_OLD - SOCKS5_PROXY_LIST_COUNT_NEW))"
echo.Cyan "Deduplicated proxy hosts from $SOCKS5_PROXY_LIST_COUNT_OLD to $SOCKS5_PROXY_LIST_COUNT_NEW, $SOCKS5_PROXY_LIST_COUNT_DIFF removed"

echo.Cyan "Whole list saved to $SOCKS5_PROXY_LIST"

echo.Cyan "Testing proxy hosts with target host - $TEST_TARGET_HOST ..."

while IFS= read -r PROXY; do
    (
        sleep "$(( RANDOM % 10 ))"
        if timeout 10 curl -s --connect-timeout "$PROXY_TIMEOUT" --retry 0 --fail --socks5-hostname "$PROXY" "$TEST_TARGET_HOST" --compressed > /dev/null; then
            flock "$TEMP" echo "$PROXY" >> "$TEMP"
        fi
    ) &
done < "$SOCKS5_PROXY_LIST"

echo.Cyan "Waiting for proxy test result..."

wait

mv "$TEMP" "$SOCKS5_PROXY_LIST"
echo.Green "SOCKS5_PROXY_LIST filtered, $(wc -l < "$SOCKS5_PROXY_LIST") proxy found!"
