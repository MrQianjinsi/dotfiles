#!/usr/bin/env bash

proxy=${CCUSAGE_PROXY:-http://127.0.0.1:7890}
timezone=${CCUSAGE_TIMEZONE:-Asia/Shanghai}
today=$(TZ="$timezone" date +%F)

ccusage_bin=${CCUSAGE_BIN:-}

if [ -n "$ccusage_bin" ] && [ ! -x "$ccusage_bin" ]; then
    ccusage_bin=
fi

if [ -z "$ccusage_bin" ] && command -v ccusage >/dev/null 2>&1; then
    ccusage_bin=$(command -v ccusage)
fi

if [ -z "$ccusage_bin" ]; then
    for candidate in "$HOME"/.nvm/versions/node/*/bin/ccusage; do
        [ -x "$candidate" ] || continue
        ccusage_bin=$candidate
    done
fi

if [ -z "$ccusage_bin" ]; then
    echo "AI ccusage?"
    exit 0
fi

ccusage_dir=$(dirname "$ccusage_bin")

if ! command -v jq >/dev/null 2>&1; then
    echo "AI jq?"
    exit 0
fi

ccusage_cmd=("$ccusage_bin" daily --json --since "$today" --until "$today" --timezone "$timezone")
if command -v timeout >/dev/null 2>&1; then
    ccusage_cmd=(timeout 20 "${ccusage_cmd[@]}")
fi

json=$(
    PATH="$ccusage_dir:$PATH" \
    http_proxy="$proxy" \
    https_proxy="$proxy" \
    all_proxy="$proxy" \
    HTTP_PROXY="$proxy" \
    HTTPS_PROXY="$proxy" \
    ALL_PROXY="$proxy" \
    "${ccusage_cmd[@]}" 2>/dev/null
)

if [ $? -ne 0 ] || [ -z "$json" ]; then
    echo "AI n/a"
    exit 0
fi

printf '%s\n' "$json" \
    | jq -r '[.totals.totalTokens // 0, .totals.totalCost // 0] | @tsv' \
    | awk '
        function human_tokens(n) {
            if (n >= 1000000000) return sprintf("%.1fB", n / 1000000000)
            if (n >= 1000000) return sprintf("%.1fM", n / 1000000)
            if (n >= 1000) return sprintf("%.1fK", n / 1000)
            return sprintf("%d", n)
        }
        {
            printf "AI %s $%.2f\n", human_tokens($1), $2
        }
    '
