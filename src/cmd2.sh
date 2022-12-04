#!/bin/sh

# work in progress
# Title:         Shellscript Starter
# Description:   Shellscript starter for Bash/Zsh/Sh/Ksh
# Author:        your-name <yourname@gmail.com>
# Date:          2022-01-10

set -eu
VERSION="0.4.0"
SCRIPT_NAME=$(basename "$0")

# Set variables
ext="png"
work_dir=$(pwd)
width=200
height=300
all=false
singlefile="-singlefile"
ppmopt=""

# Keep readlinkf function
readlinkf() {
    [ "${1:-}" ] || return 1
    max_symlinks=40
    CDPATH='' # to avoid changing to an unexpected directory

    target=$1
    [ -e "${target%/}" ] || target=${1%"${1##*[!/]}"} # trim trailing slashes
    [ -d "${target:-/}" ] && target="$target/"

    cd -P . 2>/dev/null || return 1
    while [ "$max_symlinks" -ge 0 ] && max_symlinks=$((max_symlinks - 1)); do
        if [ ! "$target" = "${target%/*}" ]; then
            case $target in
            /*) cd -P "${target%/*}/" 2>/dev/null || break ;;
            *) cd -P "./${target%/*}" 2>/dev/null || break ;;
            esac
            target=${target##*/}
        fi

        if [ ! -L "$target" ]; then
            target="${PWD%/}${target:+/}${target}"
            printf '%s\n' "${target:-/}"
            return 0
        fi
        link=$(ls -dl -- "$target" 2>/dev/null) || break
        target=${link#*" $target -> "}
    done
    return 1
}

self=$(readlinkf "$0")
script_dir=${self%/*}
# For Debian APT remove line 7 to 38 and use the following line to
# define the script_dir
# script_dir="/usr/share/shellscript_template"

# Import files
# shellcheck disable=SC1091
{
    . "${script_dir}/lib/getoptions.sh"
    . "${script_dir}/lib/main_definition.sh"
    . "${script_dir}/lib/utils.sh"
    # . "${script_dir}/lib/cmd1_definition.sh"
    # . "${script_dir}/lib/cmd2_definition.sh"
    # . "${script_dir}/lib/create_definition.sh"
    # import only one of helpers file
    # . "${script_dir}/lib/shell_helpers.sh"
    # or
    # . "${script_dir}/lib/bash_helpers.sh"
}

# Keep it. You need this for main parser.
eval "$(getoptions parser_definition parse "$0") exit 1"
parse "$@"
eval "set -- $REST"

# CHECK ENVIRONMENT
# If you need to check OS uncomment this
# if [ "$(uname)" = "Linux" ]; then
#     echo "Your OS is Linux."
# elif [ "$(uname)" = "Darwin" ]; then
#     echo "Your OS is mac."
# fi

# If you are using Bash, check Bash version
# check_bash 5

# Check dependencies of your script
check_cmd pdftoppm
# check_cmd you_dont_have_it

# Add more commands.
# Don't forget to add your command in lib/main_definition.sh
if [ $# -gt 0 ]; then
    cmd=$1
    shift
    case $cmd in
    convert)
        # eval "$(getoptions parser_definition_cmd1 parse "$0")"
        # parse "$@"
        # eval "set -- $REST"
        # shellcheck disable=SC1091
        # . "${script_dir}/src/convert.sh"
        fn_convert "$@"
        ;;
    # cmd2)
    #     eval "$(getoptions parser_definition_cmd2 parse "$0")"
    #     parse "$@"
    #     eval "set -- $REST"
    #     # shellcheck disable=SC1091
    #     . "${script_dir}/src/cmd2.sh"
    #     fn_cmd2 "$@"
    #     ;;
    # text_example)
    #     # shellcheck disable=SC1091
    #     . "${script_dir}/src/text_example.sh"
    #     fn_text
    #     ;;
    # create)
    #     eval "$(getoptions parser_definition_create parse "$0")"
    #     parse "$@"
    #     eval "set -- $REST"
    #     # shellcheck disable=SC1091
    #     . "${script_dir}/src/create.sh"
    #     fn_create "$@"
    #     ;;
    # more lines
    --) ;; # no subcommand, arguments only
    esac
fi
