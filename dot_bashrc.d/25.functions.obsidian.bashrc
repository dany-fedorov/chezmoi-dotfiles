#!/usr/bin/env bash

# This file is to be sourced

declare -r DEFAULT_OBSIDIAN_VAULTS_PATH="$HOME/wd/obsidian/vaults"
declare -r DEFAULT_OBSIDIAN_VAULT='default-3'

declare -r OBSIDIAN_DAILY_PATH='daily'
declare -r OBSIDIAN_DAILY_LOG_PATH="${OBSIDIAN_DAILY_PATH}/log"
declare -r OBSIDIAN_DAILY_LOG_CURRENT_WEEK_PATH="${OBSIDIAN_DAILY_PATH}/w-current"
declare -r OBSIDIAN_TRACK_PATH='track'
declare -r OBSIDIAN_TRACK_LOG_PATH="${OBSIDIAN_TRACK_PATH}/log"
declare -r OBSIDIAN_TRACK_LOG_CURRENT_WEEK_PATH="${OBSIDIAN_TRACK_PATH}/w-current"

__get_vault_name() {
  local -r vault=${OBSIDIAN_VAULT:-$DEFAULT_OBSIDIAN_VAULT}
  echo -n "$vault"
}

__get_all_vaults_path() {
  local -r vaults_path="${OBSIDIAN_VALUTS_PATH:-$DEFAULT_OBSIDIAN_VAULTS_PATH}"
  echo -n "$vaults_path"
}

__get_vault_path() {
  local -r all_vaults_path="$(__get_all_vaults_path)"
  local -r vault="$(__get_vault_name)"
  echo -n "${all_vaults_path}/${vault}"
}

__this_make_filename() {
  local -r _input="$@"
  local -r file_name_0=$(echo -n $_input | tr " " "-" | tr -c [:alnum:] "-" | tr -s '-')
  local -r file_name_1=${file_name_0,,}
  local -r file_name_2=${file_name_1##*(-)}
  local -r file_name_3=${file_name_2%%*(-)}
  echo -n $file_name_3
}

__urlencode() {
  printf %s "$@" | jq -sRr @uri
}

__obs_new_append() {
  local -r vault="$1"
  local -r file="$2"
  obs "obsidian://new?vault=$(__urlencode "$vault")&file=$(__urlencode "$file")&append"
}

__obs_open_vault() {
  local -r vault="$1"
  obs "obsidian://open?vault=$(__urlencode "$vault")"
}

__obs_search() {
  local -r vault="$1"
  local -r query="$2"
  obs "obsidian://search?vault=$(__urlencode "$vault")&query=$(__urlencode "$query")"
}

thisday_old() {
  local -r vault="$(__get_vault_name)"
  __obs_new_append "$vault" "${OBSIDIAN_DAILY_LOG_CURRENT_WEEK_PATH}/$(date +%F)" &
}

thisday() {
  local -r input="$1"
  if [[ "$input" = '' ]]; then
    thisdaygoto
  else
    thisdaygoto "$input"
  fi
}

thisdaygoto() {
  local -r vault="$(__get_vault_name)"
  local -r input="$1"
  local cur_year_num="$(date "+%y")"
  local cur_week_num="$(date "+%W")"
  local year_num="$(date -d "$input" +'%y')"
  local week_num="$(date -d "$input" +'%W')"
  echo "Cur year - week - date: $cur_year_num - $cur_week_num - $(date -d "$input" +'%D')"
  echo "Arg year - week - date: $year_num - $week_num - $(date -d "$input" +'%D')"
  if [[ "$year_num" = "$cur_year_num" && "$week_num" -ge "$cur_week_num" ]]; then
    __obs_new_append "$vault" "${OBSIDIAN_DAILY_LOG_CURRENT_WEEK_PATH}/$(date -d "$input" +'%d %b %y')" &
  else
  local -r vault_path="$(__get_vault_path)"
    __obs_new_append "$vault" "${vault_path}/${OBSIDIAN_DAILY_LOG_PATH}/y-${year_num}/w-${week_num}/$(date -d "$input" +'%d %b %y')" &
  fi
}

thisdaycd() {
#  local -r vault="$(__get_vault_name)"
  local -r vault_path="$(__get_vault_path)"
  cd "${vault_path}/${OBSIDIAN_DAILY_LOG_PATH}"
}

thisvault() {
  local -r vault="$(__get_vault_name)"
  __obs_open_vault "$vault" &
}

thissearch() {
  local -r vault="$(__get_vault_name)"
  local -r query="$@"
  if [[ "$query" = "" ]]; then
    __obs_search "$vault" "" &
  else
    __obs_search "$vault" "$query" &
  fi
}

thismisc() {
  local -r vault="$(__get_vault_name)"
  local -r filename_param="$@"
  local -r filename_0=$(__this_make_filename "$filename_param")
  if [[ "$filename_0" = "" ]]; then
    __obs_search "$vault" "misc/" &
  else
    __obs_new_append "$vault" "misc/${filename_1}" &
  fi
}

thistrack() {
  __obs_new_append "$vault" "${OBSIDIAN_TRACK_LOG_CURRENT_WEEK_PATH}/$(date +%F)-track" &
}

# thistrack2() {
#   __obs_new_append "$vault" "${OBSIDIAN_TRACK_LOG_CURRENT_WEEK_PATH}/$(date +'%d %b %y')-track" &
# }

thistrack-yesterday() {
  __obs_new_append "$vault" "${OBSIDIAN_TRACK_LOG_CURRENT_WEEK_PATH}/$(date -d 'yesterday' +%F)-track" &
}

thisproj() {
  local -r vault="$(__get_vault_name)"
  local -r filename_param="$@"
  local -r filename_0=$(__this_make_filename "$filename_param")
  if [[ "$filename_0" = "" ]]; then
    __obs_search "$vault" "proj/" &
  else
    __obs_new_append "$vault" "proj/${filename_0}" &
  fi
}

thisprojindex() {
  local -r vault="$(__get_vault_name)"
  __obs_new_append "$vault" "proj/index" &
}

thisorganize_daily_old() {
  local -r vault_path="$(__get_vault_path)"
  local -r week_cur_dir="${vault_path}/${OBSIDIAN_DAILY_LOG_CURRENT_WEEK_PATH}"
  local cur_year_num="$(date "+%Y")"
  local cur_week_num="$(date "+%W")"
  echo "- Current year: $cur_year_num"
  echo "- Current week: $cur_week_num"
  for file_path in "${week_cur_dir}/"*; do
    local filename="$(basename "$file_path")"
    local filename_date="${filename%%.md}"
    local year_num="$(date "+%Y" -d "$filename_date")"
    local week_num="$(date "+%W" -d "$filename_date")"
    if [[ "$year_num" = "$cur_year_num" && "$week_num" = "$cur_week_num" ]]; then
      break
    fi
    echo "- Move to y-${year_num}/w-${week_num}"
    local week_num_dir="${vault_path}/${OBSIDIAN_DAILY_LOG_PATH}/y-${year_num}/w-${week_num}"
    mkdir -p "$week_num_dir"
    mv -v "${week_cur_dir}/${filename}" "${week_num_dir}/${filename}"
  done
}

thisorganize_daily() {
  local -r vault_path="$(__get_vault_path)"
  local -r week_cur_dir="${vault_path}/${OBSIDIAN_DAILY_LOG_CURRENT_WEEK_PATH}"
  local cur_year_num="$(date "+%Y")"
  local cur_week_num="$(date "+%W")"
  echo "- Current year: $cur_year_num"
  echo "- Current week: $cur_week_num"
  for file_path in "${week_cur_dir}/"*; do
    local filename="$(basename "$file_path")"
    local filename_date="${filename%%.md}"
    local year_num="$(date "+%Y" -d "$filename_date")"
    local week_num="$(date "+%W" -d "$filename_date")"
    if [[ "$year_num" = "$cur_year_num" && "$week_num" = "$cur_week_num" ]]; then
      break
    fi
    echo "- Move to y-${year_num}/w-${week_num}"
    local week_num_dir="${vault_path}/${OBSIDIAN_DAILY_LOG_PATH}/y-${year_num}/w-${week_num}"
    mkdir -p "$week_num_dir"
    mv -v "${week_cur_dir}/${filename}" "${week_num_dir}/${filename}"
  done
}

thisorganize_track() {
  local -r vault_path="$(__get_vault_path)"
  local -r week_cur_dir="${vault_path}/${OBSIDIAN_TRACK_LOG_CURRENT_WEEK_PATH}"
  local cur_year_num="$(date "+%Y")"
  local cur_week_num="$(date "+%W")"
  echo "- Current year: $cur_year_num"
  echo "- Current week: $cur_week_num"
  for file_path in "${week_cur_dir}/"*; do
    local filename="$(basename "$file_path")"
    local filename_date="${filename%%-track.md}"
    local year_num="$(date "+%Y" -d "$filename_date")"
    local week_num="$(date "+%W" -d "$filename_date")"
    if [[ "$year_num" = "$cur_year_num" && "$week_num" = "$cur_week_num" ]]; then
      break
    fi
    echo "- Move to y-${year_num}/w-${week_num}"
    local week_num_dir="${vault_path}/${OBSIDIAN_TRACK_LOG_PATH}/y-${year_num}/w-${week_num}"
    mkdir -p "$week_num_dir"
    mv -v "${week_cur_dir}/${filename}" "${week_num_dir}/${filename}"
  done
}
