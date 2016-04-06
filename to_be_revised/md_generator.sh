#!/bin/bash

# Preconditions:
#
# * The name of the script is md_generator.sh
# * The other files are all images which represents issues

# not working
# function determineFileName() {
#   if [ -z $1 ]; then
    # md_name="issues.md"
#   else
#     md_name=$1
#   fi
# }

function redirectOutputToFile() {
  md_name="issues.md"
  exec 1>$md_name
}

function setIssuesAmount() {
  n=`ls -1 | wc -l | tr -d " "`
  let n=n-1
}

# determineFileName
redirectOutputToFile
setIssuesAmount

files=`ls -1 | grep -v "md_generator.sh" | tr '\n' ':'`

for i in `seq 1 $n`
  do f=`echo $files | cut -d: -f$i`
  echo "### Issue $i"
  echo $f
  echo
  echo "![](./$f)"
  echo
done
