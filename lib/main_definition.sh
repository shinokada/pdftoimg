# shellcheck disable=SC1083
parser_definition() {
    setup REST help:usage abbr:true -- \
        "Usage: ${2##*/} [command] [options...] [arguments...]"
    msg -- 'Options:'

    flag JPG -j --jpg -- "jpg file"
    flag ALL -a --all -- "All pages"
    flag SINGLE -s --single -- "Single page"
    param FROM -f --from -- "Page number to start"
    param INPUTDIR -i --input --"Input directory"
    param OUTPUTDIR -o --output --"Output directory"
    param WIDTH -w --width init:=200 -- "Image width. Default: 200"
    param HEIGHT -g --height init:=300 -- "Image height. Default: 300"
    disp :usage -h --help
    disp VERSION --version

    msg -- '' 'Commands: '
    msg -- 'Use command -h for a command help.'
    cmd convert -- "Convert pdf file to img file."

    msg -- '' "Description: 
============
This script is a wrapper for Poppler/pdftoimg. This converts pdf files to image files. 
The default dimensions: width ${width}px, height ${height}px. 

Usage:  $script_name [ -d dir_name ][ -j ][ -v ][ -w 200 ][ -g 300 ] [ -l 2 ][ -s ]
======
    -a  flag. All pages. Default: false. Convert a single page.
    -f  Page number to start from
    -g  Size of image height
    -i  Input directory
    -j  flag. jpeg (Default png) 
    -h  flag. Show the help 
    -o  Output directory
    -s  Only single page
    -v  flag. Get the tool version  
    -w  Size of image width

Check more pdftoppm usages at https://www.mankier.com/1/pdftoppm.

Examples: 
=========
    # Convert the first page of all pdfs in the current directory to png files.
    $ pdftoimg

    # Set a target directory.
    $ pdftoimg -d path/to/input-dir
    $ pdftoimg -d path/to/input-dir -o path/to/output-dir

    # Convert the first page of all pdfs in the current directory to dimensions 200x250px png files.
    $ pdftoimg -w 200 -h 250
    $ pdftoimg -w 200 -h 250 -i path/to/input-dir
    
    # Above command plus set a directory and pdftoppm option
    $ pdftoimg -s 300 250 path/to/dir -gray

    # Convert the first page of all pdfs in the current directory to dimensions 200x250px jpg files.
    $ pdftoimg -j -s 200 250

    # Above command plut set a directory and pdftoppm option
    $ pdftoimg -j -s 200 250 Downloads/test -gray

    # Convert all PDF pages in a target directory.
    $ pdftoimg -a Downloads/dir
"
}
