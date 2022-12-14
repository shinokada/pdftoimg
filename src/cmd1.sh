#!/usr/bin/env bash

########################
# Author: Shinichi Okada
# Version : v0.0.3
# Date: 2021-03-28
###########################

# Global variables

script_name=$(basename "$0")
version="v0.0.3"
ext="png"
work_dir=$(pwd)
width=160
height=227
all=false
singlefile="-singlefile"
ppmopt=""

############## Functions ###############

usage() {
    cat <<EOF

Name: 
=====
$script_name

Description: 
============
This script is a wrapper for Poppler/pdftoimg. This converts pdf files to image files. 
The default dimensions: width ${width}px, height ${height}px. 

Usage:  $script_name [ -d dir_name ][ -j ][ -v ][ -s 200 200 ][ ... ]
======
    -j  flag. jpeg (Default png) 
    -h  flag. Show the help 
    -v  flag. Get the tool version  
    -s  switch. Size of image (Default: ${width}px x ${height}px)
    -a  flag. All pages. Default: false. Convert a single page.

Check more pdftoppm usages at https://www.mankier.com/1/pdftoppm.

Examples: 
=========
    # Convert the first page of all pdfs in the current directory to png files.
    $ pdftoimg

    # Set a target directory.
    $ pdftoimg path/to/dir

    # Convert the first page of all pdfs in the current directory to dimensions 200x250px png files.
    $ pdftoimg -s 200 250
    $ pdftoimg -s 200 250 path/to/dir
    
    # Above command plus set a directory and pdftoppm option
    $ pdftoimg -s 300 250 path/to/dir -gray

    # Convert the first page of all pdfs in the current directory to dimensions 200x250px jpg files.
    $ pdftoimg -j -s 200 250

    # Above command plut set a directory and pdftoppm option
    $ pdftoimg -j -s 200 250 Downloads/test -gray

    # Convert all PDF pages in a target directory.
    $ pdftoimg -a Downloads/dir

EOF
    exit 2
}

POSITIONAL=()
# while arguments count > 0
while (($# > 0)); do
    case "$1" in
    -j | --jpeg)
        ext="jpeg"
        shift # shift once since flags have no values
        ;;
    -v | --version)
        echo $version
        exit 0
        ;;
    -a | --all)
        all=true
        shift
        ;;
    -s | --size)
        # echo "switch $1 with value: $2"
        width=$2
        height=$3
        shift 3 # shift 3 to bypass switch and its value
        ;;
    -h | --help)
        usage
        ;;
    *) # unknown flag/switch
        POSITIONAL+=("$1")
        shift
        ;;
    esac
done

set -- "${POSITIONAL[@]}" #restore positional params

######### Functions #############

convert() {
    # set work_dir for ls at the end
    work_dir=$1
    for file in "$1"/*; do
        if [[ $file == *.pdf ]]; then
            filename="${file%.*}"
            # echo "$filename"
            # check if the length of $singlefile is greater than 0
            # pdftoppm -png sample.pdf image converts pdf to png files 
            # as image-1.png, image-2.png, image-3.png, etc
            if [[ -n "$singlefile" ]]; then
                # convert only the single file, -f 1 means page 1
                # don't add quotes for $2
                pdftoppm "$file" "$filename" -"${ext}" -f 1 "$singlefile" -scale-to-x "$width" -scale-to-y "$height" $2
            else
                pdftoppm "$file" "$filename" -"${ext}" -f 1 -scale-to-x "$width" -scale-to-y "$height" $2
            fi
        fi
    done
}

####### Main function ############

# Check if you have pdftoppm
if ! command -v pdftoppm &>/dev/null; then
    echo "Please install pdftoppm from https://poppler.freedesktop.org/."
    exit 1
fi

# all pages
if [ $all == true ]; then
    singlefile=""
fi

# Find ppm options which have -gray or -something in POSITIONAL array
ppmopt=$(printf '%s\n' "${POSITIONAL[@]}" | grep "-")
# echo "$ppmopt"

# Check if a positional parameter is a directory
# Use may use like pdftoimg Downloads/test
# forgetting to add -d.
if [ "${#POSITIONAL[@]}" -gt 0 ]; then
    # echo "${POSITIONAL[@]}"
    for opt in "${POSITIONAL[@]}"; do
        if [[ ! $opt == -* ]] && [[ -d "$HOME/$opt" ]]; then
            # it is a dir
            echo "==========="
            echo "Converting the directory: $HOME/$opt"
            echo "==========="
            convert "$HOME/$opt" "$ppmopt"
        elif [[ $opt == -* ]]; then
            echo "from elif: $opt"
            convert "$work_dir" "$ppmopt"
        fi
    done
else
    # if no argument means convert in the current dir
    echo "==========="
    echo "Converting the directory: $work_dir"
    echo "==========="
    convert "$work_dir" "$ppmopt"
fi

ls "$work_dir"

exit 0
