#!/usr/bin/env bash

set -u

home_used=$(df -P /home | awk 'NR == 2 { gsub(/%/, "", $5); print $5 }')

mounts=$(df -hP -T | awk '
    NR > 1 && $7 != "/efi" && $2 !~ /^(devtmpfs|tmpfs|efivarfs|proc|sysfs|cgroup2|debugfs|tracefs|securityfs|pstore|mqueue|hugetlbfs|configfs|fusectl|autofs|overlay|squashfs|ramfs|nsfs)$/ {
        printf "%-16s %4s  %6s / %-6s  %6s 可用\n", $7, $6, $4, $3, $5
    }
')

if [[ -z "$mounts" ]]; then
    mounts="未找到实际存储挂载点"
fi

tooltip=$(printf '<b>存储挂载点</b>\n<tt>%s</tt>' "$mounts")

jq -cn \
    --arg text "${home_used:-?}% " \
    --arg tooltip "$tooltip" \
    '{text: $text, tooltip: $tooltip}'
