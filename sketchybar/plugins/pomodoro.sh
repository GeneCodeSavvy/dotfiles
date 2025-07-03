#!/bin/bash

# --- Configuration ---
HISTORY_FILE="$HOME/.config/pomodoro/history"
NOTIFICATION_SOUND="Frog"

# Create the directory and history file if they don't exist
mkdir -p "$(dirname "$HISTORY_FILE")"
touch "$HISTORY_FILE"

get_status_icon() {
	case "$1" in
		"STAND_BY")   echo "󰓛" ;;
		"PAUSE")      echo "󰏤" ;;
		"LONG_PAUSE") echo "" ;;
		"WORK")       echo "󰃁" ;;
	esac
}

get_status_label() {
	case "$1" in
		"STAND_BY")   echo "Start" ;;
		"PAUSE")      echo "Pause take deep breaths" ;;
		"LONG_PAUSE") echo "Break" ;;
		"WORK")       echo "Work" ;;
	esac
}

get_status_text() {
	case "$1" in
		"STAND_BY")   echo "Waiting..." ;;
		"PAUSE")      echo "relaxing..." ;;
		"LONG_PAUSE") echo "chill out..." ;;
		"WORK")       echo "working..." ;;
	esac
}

get_status_on_end_text() {
	case "$1" in
		"STAND_BY")   echo " " ;;
		"PAUSE")      echo "Let's continue!" ;;
		"LONG_PAUSE") echo "It's time for work!" ;;
		"WORK")       echo "Let's take a break" ;;
	esac
}

get_status_time() { # Duration in minutes
	case "$1" in
		"STAND_BY")   echo 0 ;;
		"PAUSE")      echo 5 ;;
		"LONG_PAUSE") echo 20 ;;
		"WORK")       echo 25 ;;
	esac
}

is_valid_status() {
    case "$1" in
        "STAND_BY"|"PAUSE"|"LONG_PAUSE"|"WORK") return 0 ;;
        *) return 1 ;;
    esac
}


# --- Core Functions ---

send_notification() {
	local text="$1"
	local subtitle="$2"
	if command -v sketchybar &>/dev/null; then
		sketchybar --trigger "pomodoro_notification"
        afplay "/System/Library/Sounds/${NOTIFICATION_SOUND}.aiff"
        mac-brightnessctl -f 3 0.6
    fi
}

write_status_to_file() {
	local status="$1"
    ! is_valid_status "$status" && return 1

	local counter_time
    counter_time=$(get_status_time "$status")
	
    local timestamp
	timestamp=$(date +"%Y-%m-%d %H:%M:%S")
	echo "$timestamp $status $counter_time" >>"$HISTORY_FILE"
}

read_last_status_line() {
	tail -n 1 "$HISTORY_FILE"
}

get_current_status() {
	local last_line
	last_line=$(read_last_status_line)
	[[ -z "$last_line" ]] && { echo "STAND_BY"; return; }

	local date_part time_part status_name counter
	read -r date_part time_part status_name counter <<<"$last_line"
	local timestamp="$date_part $time_part"

	! is_valid_status "$status_name" && { echo "STAND_BY"; return; }

	local start_time now elapsed duration
	start_time=$(date -j -f "%Y-%m-%d %H:%M:%S" "$timestamp" +"%s")
	now=$(date +"%s")
	elapsed=$((now - start_time))
	duration=$(( $(get_status_time "$status_name") * 60 ))

	if [[ "$elapsed" -lt "$duration" ]]; then
		echo "$status_name"
	else
		echo "STAND_BY"
	fi
}

get_next_status_based_on_history() {
	local last_statuses
	last_statuses=($(tail -n 7 "$HISTORY_FILE" | awk '{print $3}'))

	if [[ "${#last_statuses[@]}" -eq 7 ]]; then
		local is_pattern_match=true
		for i in {0..6}; do
			if ((i % 2 == 0)); then
				[[ "${last_statuses[$i]}" != "WORK" ]] && is_pattern_match=false
			else
				[[ "${last_statuses[$i]}" != "PAUSE" ]] && is_pattern_match=false
			fi
		done
		if $is_pattern_match; then
			echo "LONG_PAUSE"
			return
		fi
	fi
	echo "PAUSE"
}

determine_next_status() {
	local current_status=$1
	case "$current_status" in
		"WORK") get_next_status_based_on_history ;;
		"PAUSE" | "LONG_PAUSE") echo "WORK" ;;
		*) echo "WORK" ;;
	esac
}

check_and_advance_status_if_needed() {
	local last_line
	last_line=$(read_last_status_line)
	[[ -z "$last_line" ]] && return

	local date_part time_part status_name counter
	read -r date_part time_part status_name counter <<<"$last_line"
	local timestamp="$date_part $time_part"

    ! is_valid_status "$status_name" && return
    [[ "$(get_status_time "$status_name")" -eq 0 ]] && return

	local start_time now elapsed_minutes
	start_time=$(date -j -f "%Y-%m-%d %H:%M:%S" "$timestamp" +"%s")
	now=$(date +"%s")
	elapsed_minutes=$(((now - start_time) / 60))

	if [[ "$elapsed_minutes" -ge "$counter" ]]; then
		local next_status on_end_text next_status_text
		next_status=$(determine_next_status "$status_name")
		write_status_to_file "$next_status"
		
		on_end_text=$(get_status_on_end_text "$status_name")
		next_status_text=$(get_status_text "$next_status")
		send_notification "$on_end_text" "Time for: ${next_status_text}"
	fi
}

update() {
	check_and_advance_status_if_needed
	current_status=$(get_current_status)

	if [[ "$current_status" == "STAND_BY" ]]; then
		sketchybar --set "$NAME" icon="$(get_status_icon 'STAND_BY')" \
		                              label="$(get_status_label 'STAND_BY')"
	else
		local last_line date_part time_part _ counter
		last_line=$(read_last_status_line)
		read -r date_part time_part _ counter <<<"$last_line"
		local timestamp="$date_part $time_part"

		local start_time now duration_sec elapsed_sec remaining_sec minutes seconds
		start_time=$(date -j -f "%Y-%m-%d %H:%M:%S" "$timestamp" +"%s")
		now=$(date +"%s")
		duration_sec=$((counter * 60))
		elapsed_sec=$((now - start_time))
		remaining_sec=$((duration_sec - elapsed_sec))

		if [[ "$remaining_sec" -gt 0 ]]; then
			minutes=$((remaining_sec / 60))
			seconds=$((remaining_sec % 60))
			
			local icon label
			icon=$(get_status_icon "$current_status")
			label=$(printf "%02d:%02d" "$minutes" "$seconds")
			sketchybar --set "$NAME" icon="$icon" label="$label"
		else
			sketchybar --set "$NAME" icon="$(get_status_icon 'STAND_BY')" \
			                              label="$(get_status_label 'STAND_BY')"
		fi
	fi
}

# --- Command Line Interface ---

COMMAND="$1"
STATUS_ARG="$2"

case "$COMMAND" in
"start")
	NEW_STATUS=$(echo "$STATUS_ARG" | tr '[:lower:]' '[:upper:]')
    ! is_valid_status "$NEW_STATUS" && exit 1
	case "$NEW_STATUS" in
	"WORK" | "PAUSE" | "LONG_PAUSE")
		write_status_to_file "$NEW_STATUS"
		update
		;;
	esac
    send_notification "Timer started"
	;;
"stop")
	write_status_to_file "STAND_BY"
	send_notification "Timer stopped" "Ready to start a new session."
	update
	;;
"update")
	update
	;;
*)
	echo "Usage: $0 {start|stop|update}" >&2
	exit 1
	;;
esac
