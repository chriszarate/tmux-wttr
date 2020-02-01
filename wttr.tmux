#!/usr/bin/env bash

# Get current weather from wttr.in.

get_tmux_option() {
  local option_value
  option_value=$(tmux show-option -gqv "$1")

  if [ -z "$option_value" ]; then
    echo "$2"
  else
    echo "$option_value"
  fi
}

update_status() {
	local placeholder
	local status_value

	placeholder="\#{wttr}"
	status_value="$(get_tmux_option "$1")"

	tmux set-option -gq "$1" "${status_value/$placeholder/$2}"
}

get_weather() {
	local format

	format=$(get_tmux_option "@wttr_format" "%C+%t")

	curl -s "https://wttr.in/?format=$format" | sed -e 's/°F/°/' -e 's/+//' -e 's/\s+$//' | tr '[:upper:]' '[:lower:]'
}

get_weather_from_cache() {
	local cache_file
	local cache_ttl
	local current_dir
	local now
	local mod

	current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	cache_file="$current_dir/cache"
	cache_ttl=$(get_tmux_option "@wttr_cache_ttl" 900)

	if [[ -f "$cache_file" ]]; then
		now=$(date +%s)
		mod=$(date -r "$cache_file" +%s)
		if [[ $(( now - mod )) -gt $cache_ttl ]]; then
			rm "$cache_file"
		fi
	fi

	if [[ ! -f "$cache_file" ]]; then
		get_weather > "$cache_file"
	fi

	cat "$cache_file"
}

main() {
	output="$(get_weather_from_cache)"

	update_status "status-left" "$output"
	update_status "status-right" "$output"
}

main
