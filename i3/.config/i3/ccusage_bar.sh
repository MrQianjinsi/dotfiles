#!/usr/bin/env bash

proxy=${CCUSAGE_PROXY:-http://127.0.0.1:7890}
timezone=${CCUSAGE_TIMEZONE:-Asia/Shanghai}
today=$(TZ="$timezone" date +%F)

if [ -x "$HOME/.nvm/versions/node/v22.14.0/bin/ccusage" ]; then
    ccusage_bin="$HOME/.nvm/versions/node/v22.14.0/bin/ccusage"
elif command -v ccusage >/dev/null 2>&1; then
    ccusage_bin=$(command -v ccusage)
else
    echo "AI ccusage?"
    exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "AI jq?"
    exit 0
fi

ccusage_cmd=("$ccusage_bin" daily --json --since "$today" --until "$today" --timezone "$timezone")
if command -v timeout >/dev/null 2>&1; then
    ccusage_cmd=(timeout 20 "${ccusage_cmd[@]}")
fi

json=$(
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
