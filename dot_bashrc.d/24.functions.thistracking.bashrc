#!/usr/bin/env bash

# This file is to be sourced

#
# utils
#

#declare -r __THIS_SEP=___
#
#__this_make_filename() {
#  local -r _input="$@";
#  local -r file_name_0=$(echo -n $_input | tr " " "-" | tr -c [:alnum:] "-" | tr -s '-');
#  local -r file_name_1=${file_name_0,,}
#  local -r file_name_2=${file_name_1##*(-)}
#  local -r file_name_3=${file_name_2%%*(-)}
#  echo -n $file_name_3
#}
#
#__this_day_date_filename() {
#    echo -n $(date +"%F" | tr -d "\n" | tr -c '[:alnum:]' "-")
#}
#
#__this_day_date_friendly() {
#    echo -n $(LC_ALL=en_US.utf8 date +'%a %d %b %Y')
#}
#
#__this_full_date_friendly() {
#    echo -n $(LC_ALL=en_US.utf8 date +'%c')
#}
#
#__this_org_dir() {
#    echo -n "${DF_DROPBOX_PATH:-$HOME/Dropbox}/org"
#}
#
#__this_open_file() {
#    e $1
#}
#
#__this_open_dir() {
#    e $1
#}
#
##
## this day
##
#
#__thisday_dir() {
#    local -r day_date=$(__this_day_date_filename)
#    local -r day_name=day-${day_date}
#    local -r dir="$(__this_org_dir)/days/${day_name}"
#    echo -n $dir
#}
#
#__thisday_filename() {
#    local -r _suffix="$@";
#    local suffix="${_suffix:-default}"
#    if [[ $suffix = '__default__' ]]; then
#        suffix=default
#    fi
#    local effective_file_suffix=""
#    if [[ $suffix != 'default' ]]; then
#	    effective_file_suffix="${__THIS_SEP}$(__this_make_filename "$suffix")"
#    fi
#    local -r day_date=$(__this_day_date_filename)
#    local -r day_name=day-${day_date}
#    echo -n ${day_name}${effective_file_suffix}.org
#}
#
#__thisday_title() {
#    local -r _suffix="$@";
#    local suffix="${_suffix:-default}"
#    if [[ $suffix = '__default__' ]]; then
#        suffix=default
#    fi
#    local effective_title_suffix=""
#    if [[ $suffix != 'default' ]]; then
#	    effective_title_suffix=" -- ${suffix^}"
#    fi
#    local -r day_date_friendly=$(__this_day_date_friendly)
#    echo -n ${day_date_friendly}${effective_title_suffix}
#}
#
#__thisday_create() {
#    local -r file="$1"
#    shift
#    local -r title=$(__thisday_title "$@")
#    local -r date_friendly=$(__this_full_date_friendly)
#
#    touch $file
#
#    echo "#+startup: showall" >> $file
#    echo "#+options: toc:nil" >> $file
#    echo "" >> $file
#    echo "#+title:  $title" >> $file
#    echo "#+author: Dany Fedorov" >> $file
#    echo "#+date:   $date_friendly" >> $file
#    echo "" >> $file
#}
#
#thisday() {
#    local -r dir="$(__thisday_dir)"
#    local -r filename=$(__thisday_filename "$@")
#    local -r file=$dir/$filename
#
#    mkdir -p "$dir"
#    if [[ ! -e "$file" ]]; then
#        __thisday_create "$file" "$@"
#    fi
#    __this_open_file "$file"
#}
#
#__lib__thisday_list() {
#    local -r word="$@"
#    prefix=''
#    if [[ $word != '' ]]; then
#        prefix=${__THIS_SEP}$(__this_make_filename "$word")
#    fi
#    local -r day_date=$(__this_day_date_filename)
#    local -r day_name=day-${day_date}
#    local -r dir="$(__thisday_dir)"
##     echo "$prefix --- $dir/${day_name}${prefix}*.org"
#    for f in $(ls $dir/${day_name}${prefix}*.org 2> /dev/null); do
#	    stripped_f_0=${f##$dir/${day_name}}
#	    stripped_f_1=${stripped_f_0##${__THIS_SEP}}
#	    stripped_f=${stripped_f_1%%.org}
#	    if [[ $stripped_f = '' ]]; then
#	        echo '__default__'
#	    else
#	        echo $stripped_f
#	    fi
#    done
#    if [[ $word != '' && 'default' =~ ^"$word".*$ ]]; then
#        echo __default__
#    fi
#    if [[ $word != '' && '__default__' =~ ^"$word".*$ ]]; then
#        echo __default__
#    fi
#}
#
#__thisday_list() {
#    __lib__thisday_list "$@" | sort
#}
#
#__thisday-completeion() {
#    local words=($COMP_LINE)
#    unset 'words[0]'
#    case $COMP_CWORD in
#     1)
#       COMPREPLY=($(__thisday_list "${words[@]}"))
#       ;;
#     2)
#       COMPREPLY=()
#       ;;
#    esac
#}
#
#thisday-show() {
#  if [[ $1 = "" ]]; then
#    __thisday_list
#  else
#    batcat -p "$(__thisday_dir)/$(__thisday_filename $1)"
#  fi
#}
#
#complete -F __thisday-completeion thisday thisday-show
#
##
## this estimate
##
#
#estimates() {
#  local -r dir="$(__thisestimate_dir)"
#  mkdir -p "$dir"
#  __this_open_dir $dir
#}
#
#__thisestimate_dir(){
#    local -r dir="$(__this_org_dir)/estimates"
#    echo -n $dir
#}
#
#__thisestimate_filename() {
#    local -r _input="$@"
#    local -r day_date=$(__this_day_date_filename)
#    local -r day_name=day-${day_date}
#    echo -n estimate${__THIS_SEP}$(__this_make_filename ${_input:-estimates-file-on-$day_name}).org
#}
#
#__thisestimate_title() {
#    local -r _input="$@"
#    local -r title="${_input:-Estimates file on $day_date_friendly}";
#    local -r effective_title="Estimates for: ${title^}"
#    echo -n $effective_title
#}
#
#__thisestimate_create() {
#    local -r file="$1"
#    local -r date_friendly=$(__this_full_date_friendly)
#
#    shift
#    local -r title=$(__thisestimate_title "$@")
#
#    touch $file
#    echo "#+startup: showall" >> $file
#    echo "#+options: toc:nil" >> $file
#    echo >> $file
#    echo "#+title:  $title" >> $file
#    echo "#+author: Dany Fedorov" >> $file
#    echo "#+date:   $date_friendly" >> $file
#    echo "" >> $file
#    echo "* Work Plan Table" >> $file
#    echo "" >> $file
#    echo '#+CONSTANTS: unit_testing_coef=0 code_review_coef=1.3 bug_fixing_coef=1.3' >> $file
#    echo '' >> $file
#    echo '- Unit testing coefficient: 0' >> $file
#    echo '- Code review coefficient:  1.3' >> $file
#    echo '- Bug fixing coefficient:   1.3' >> $file
#    echo '' >> $file
#    echo '|---+---+--------------------+--------+---------+--------+---+--------+---------|' >> $file
#    echo '|   | N | Task               |    Opt |      BG |   Pess |   |    Exp | Fin Exp |' >> $file
#    echo '| ! | N | Task               |  Opt_h |    BG_h | Pess_h |   |  Exp_h |  FExp_h |' >> $file
#    echo '|---+---+--------------------+--------+---------+--------+---+--------+---------|' >> $file
#    echo '| # | 1 | -                  |   0.00 |    0.00 |   0.00 |   |   0.00 |    0.00 |' >> $file
#    echo '|---+---+--------------------+--------+---------+--------+---+--------+---------|' >> $file
#    echo '| _ |   |                    | OTot_h | BGTot_h | PTot_h |   | ETot_h | FETot_h |' >> $file
#    echo '| # |   | Totals in hours    |   0.00 |    0.00 |  00.00 |   |   0.00 |    0.00 |' >> $file
#    echo '|---+---+--------------------+--------+---------+--------+---+--------+---------|' >> $file
#    echo '| _ |   |                    | OTot_d | BGTot_d | PTot_d |   | ETot_d | FETot_d |' >> $file
#    echo '| # |   | Totals in days     |   0.00 |  0.0000 |   0.00 |   |  0.000 |   0.000 |' >> $file
#    echo '|---+---+--------------------+--------+---------+--------+---+--------+---------|' >> $file
#    echo '#+TBLFM: $4=$4;%.2f::$5=$5;%.2f::$6=$6;%.2f::$BGTot_h=vsum(@3..@-2);%.2f::$BGTot_d=$BGTot_h/8;%.4f::$OTot_h=vsum(@3..@-2);%.2f::$OTot_d=$OTot_h/8;%.4f::$PTot_h=vsum(@3..@-2);%.2f::$PTot_d=$PTot_h/8;%.4f::$8=round(($Opt_h + 4 * $BG_h + $Pess_h)/6, 2);%.2f::$9=round($Exp_h + $unit_testing_coef * $BG_h + $code_review_coef * $BG_h + $bug_fixing_coef * $BG_h, 2);%.2f::$ETot_h=vsum(@3..@-2);%.2f::$ETot_d=$ETot_h/8;%.4f::$FETot_h=vsum(@3..@-2);%.2f::$FETot_d=$FETot_h/8;%.4f' >> $file
#    echo '#+TBLFM: @3$2..@-5$2=@#-2' >> $file
#    echo '' >> $file
#    echo '# Legend:' >> $file
#    echo '# - Opt, BG, Pess - Optimistig, Best Guess and Pessimistic estimates in hours' >> $file
#    echo '# - Exp - Expected time based on three point estimate' >> $file
#    echo '# - Fin Exp - Final Expected time based on Exp + coefficiens of unit testing, code review and bug fixing' >> $file
#    echo "" >> $file
#    echo "* Task Details" >> $file
#    echo "" >> $file
#}
#
#thisestimate() {
#    local -r day_date_friendly=$(__this_day_date_friendly)
#    local -r dir="$(__thisestimate_dir)"
#    local -r filename=$(__thisestimate_filename "$@")
#    local -r file="$dir/$filename"
#    mkdir -p "$dir"
#    if [[ ! -e "$file" ]]; then
#        __thisestimate_create "$file" "$@"
#    fi
#    __this_open_file $file
#}
#
#__lib__thisestimate_list() {
#    local -r word="$@"
#    prefix=''
#    if [[ $word != '' ]]; then
#        prefix=${__THIS_SEP}$(__this_make_filename "$word")
#    fi
#    local -r day_date=$(__this_day_date_filename)
#    local -r day_name=day-${day_date}
#    local -r dir="$(__thisestimate_dir)"
#    for f in $(ls $dir/estimate${prefix}*.org 2>/dev/null); do
#	    stripped_f_0=${f##$dir/estimate}
#	    stripped_f_1=${stripped_f_0##${__THIS_SEP}}
#	    stripped_f=${stripped_f_1%%.org}
#	    echo $stripped_f
#    done
#}
#
#__thisestimate_list() {
#    __lib__thisestimate_list "$@" | sort
#}
#
#__thisestimate-completeion() {
#    local words=($COMP_LINE)
#    unset 'words[0]'
#    case $COMP_CWORD in
#     1)
#       COMPREPLY=($(__thisestimate_list "${words[@]}"))
#       ;;
#     2)
#       COMPREPLY=()
#       ;;
#    esac
#}
#
#thisestimate-show() {
#  if [[ $1 = "" ]]; then
#    __thisestimate_list
#  else
#    batcat -p "$(__thisestimate_dir)/$(__thisestimate_filename $1)"
#  fi
#}
#
#thisestimate-delete() {
#  local -r dir="$(__thisestimate_dir)"
#  local -r file="$dir/$(__thisestimate_filename "$@")"
#  rm -v $file
#}
#
#
#complete -F __thisestimate-completeion thisestimate thisestimate-show thisestimate-delete
#
##
## this misc
##
#
#__thismisc_filename() {
#    local -r day_date=$(__this_day_date_filename)
#    local -r day_name=day-${day_date}
#    local -r _input="$@"
#    local -r __file_name="${_input:-misc-file-on-$day_name}";
#    local -r _file_name=$(__this_make_filename  "$__file_name");
#    local -r file_name=${_file_name,,};
#    local -r effective_file_suffix="${__THIS_SEP}$file_name"
#    echo -n misc${effective_file_suffix}.org
#}
#
#__thismisc_title() {
#    local -r day_date_friendly=$(__this_day_date_friendly)
#    local -r title="${1:-Misc file on $day_date_friendly}";
#    local -r effective_title="${title^}"
#    echo -n $effective_title
#}
#
#__thismisc_create() {
#    local -r file="$1"
#    shift
#    local -r title_input="$@"
#
#    local -r date_friendly=$(__this_full_date_friendly)
#    local -r title=$(__thismisc_title "$title_input")
#
#    touch $file
#
#    echo "#+startup: showall" >> $file
#    echo '' >> $file
#    echo "#+title:  $title" >> $file
#    echo "#+date:   $date_friendly" >> $file
#}
#
#__thismisc_dir() {
#    echo -n "$(__this_org_dir)/misc"
#}
#
#__thisarchive_dir() {
#    echo -n "$(__this_org_dir)/archive"
#}
#
#thismisc() {
#    if [[ "$@" = "" ]]; then
#        thismisc-show
#        return
#    fi
#    local -r dir="$(__thismisc_dir)"
#    local -r file="$dir/$(__thismisc_filename "$@")"
#    mkdir -p $dir
#    if [[ ! -e "$file" ]]; then
#        __thismisc_create "$file" "$@"
#    fi
#    e $file
#}
#
#__lib__thismisc_list() {
#    local -r word="$@"
#    prefix=''
#    if [[ $word != '' ]]; then
#        prefix=${__THIS_SEP}$(__this_make_filename "$word")
#    fi
#    local -r day_date=$(__this_day_date_filename)
#    local -r day_name=day-${day_date}
#    local -r dir="$(__thismisc_dir)"
#    for f in $(ls $dir/misc${prefix}*.org 2> /dev/null); do
#	    stripped_f_0=${f##$dir/misc}
#	    stripped_f_1=${stripped_f_0##${__THIS_SEP}}
#	    stripped_f=${stripped_f_1%%.org}
#	    echo $stripped_f
#    done
#}
#
#__thismisc_list() {
#    __lib__thismisc_list "$@" | sort
#}
#
#__thismisc-completeion() {
#    local -r words=($COMP_LINE)
#    case $COMP_CWORD in
#     1)
#       COMPREPLY=($(__thismisc_list ${words[1]}))
#       ;;
#     2)
#       COMPREPLY=()
#       ;;
#    esac
#}
#
#thismisc-show() {
#  if [[ $1 = "" ]]; then
#    __thismisc_list
#  else
#    local -r dir="$(__this_org_dir)/misc"
#    local -r filepath="$dir/$(__thismisc_filename $1)"
#    batcat -p "${filepath}"
#  fi
#}
#
#thismisc-match() {
#    local -r dir="$(__thismisc_dir)"
#    for f in $(ls $dir/misc${__THIS_SEP}*$1*.org 2> /dev/null); do
#	    stripped_f_0=${f##$dir/misc}
#	    stripped_f_1=${stripped_f_0##${__THIS_SEP}}
#	    stripped_f=${stripped_f_1%%.org}
#	    echo $stripped_f
#    done
#}
#
#thismisc-find() {
#    __thismisc_list | fzf | thismisc $(</dev/stdin)
#}
#
#thismisc-rename() {
#  local -r dir="$(__thismisc_dir)"
#  if [[ "$1" = "" || "$2" = "" ]]; then
#    echo 'Bad arguments'
#    return
#  fi
#  local -r file0="$dir/$(__thismisc_filename "$1")"
#  local -r file1="$dir/$(__thismisc_filename "$2")"
#  mv -v $file0 $file1
#}
#
#thismisc-delete() {
#  local -r dir="$(__thismisc_dir)"
#  local -r file="$dir/$(__thismisc_filename "$@")"
#  rm -v $file
#}
#
#thismisc-archive() {
#  local -r dir="$(__thismisc_dir)"
#  local -r filename="$(__thismisc_filename "$@")"
#  local -r file="$dir/$filename"
#  local -r archive_dir="$(__thisarchive_dir)"
#  local -r archive_file="$archive_dir/$filename"
#  mv -v $file $archive_file
#}
#
#complete -F __thismisc-completeion thismisc thismisc-show
#
