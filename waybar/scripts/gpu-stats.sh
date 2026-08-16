#!/usr/bin/env bash

set -u

mode=${1:-usage}
shopt -s nullglob
busy_files=(/sys/class/drm/card[0-9]*/device/gpu_busy_percent)

if (( ${#busy_files[@]} == 0 )); then
    printf '{"text":"GPU N/A","tooltip":"No readable amdgpu metrics found"}\n'
    exit 0
fi

device_dir=${busy_files[0]%/gpu_busy_percent}

read_metric() {
    local metric_path=$1
    if [[ -r $metric_path ]]; then
        sed -n '1p' "$metric_path"
    else
        printf '0\n'
    fi
}

case $mode in
    summary)
        busy=$(read_metric "$device_dir/gpu_busy_percent")
        used=$(read_metric "$device_dir/mem_info_vram_used")
        total=$(read_metric "$device_dir/mem_info_vram_total")
        gtt_used=$(read_metric "$device_dir/mem_info_gtt_used")
        gtt_total=$(read_metric "$device_dir/mem_info_gtt_total")

        if (( total == 0 )); then
            printf '{"text":"GPU %s%%","tooltip":"AMD GPU utilization: %s%%\\nNo readable VRAM metrics found","percentage":%s}\n' \
                "$busy" "$busy" "$busy"
            exit 0
        fi

        read -r used_gib total_gib gtt_used_gib gtt_total_gib percentage < <(
            awk -v used="$used" -v total="$total" -v gtt_used="$gtt_used" -v gtt_total="$gtt_total" \
                'BEGIN {
                    printf "%.1f %.1f %.1f %.1f %.0f\n", \
                        used / 1073741824, total / 1073741824, \
                        gtt_used / 1073741824, gtt_total / 1073741824, \
                        used * 100 / total
                }'
        )

        printf '{"text":"%s%% 󰢮 %s%% ","tooltip":"GPU utilization: %s%%\\nVRAM: %s/%s GiB (%s%%)\\nGTT shared: %s/%s GiB","percentage":%s}\n' \
            "$busy" "$percentage" "$busy" "$used_gib" "$total_gib" "$percentage" \
            "$gtt_used_gib" "$gtt_total_gib" "$busy"
        ;;
    usage)
        busy=$(read_metric "$device_dir/gpu_busy_percent")
        printf '{"text":"GPU %s%%","tooltip":"AMD GPU utilization: %s%%","percentage":%s}\n' \
            "$busy" "$busy" "$busy"
        ;;
    memory)
        used=$(read_metric "$device_dir/mem_info_vram_used")
        total=$(read_metric "$device_dir/mem_info_vram_total")
        gtt_used=$(read_metric "$device_dir/mem_info_gtt_used")
        gtt_total=$(read_metric "$device_dir/mem_info_gtt_total")

        if (( total == 0 )); then
            printf '{"text":"VRAM N/A","tooltip":"No readable VRAM metrics found"}\n'
            exit 0
        fi

        read -r used_gib total_gib gtt_used_gib gtt_total_gib percentage < <(
            awk -v used="$used" -v total="$total" -v gtt_used="$gtt_used" -v gtt_total="$gtt_total" \
                'BEGIN {
                    printf "%.1f %.1f %.1f %.1f %.0f\n", \
                        used / 1073741824, total / 1073741824, \
                        gtt_used / 1073741824, gtt_total / 1073741824, \
                        used * 100 / total
                }'
        )

        printf '{"text":"VRAM %s/%sG","tooltip":"VRAM: %s/%s GiB\\nGTT shared: %s/%s GiB","percentage":%s}\n' \
            "$used_gib" "$total_gib" "$used_gib" "$total_gib" \
            "$gtt_used_gib" "$gtt_total_gib" "$percentage"
        ;;
    *)
        printf '{"text":"GPU N/A","tooltip":"Unknown gpu-stats mode"}\n'
        ;;
esac
