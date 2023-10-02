#!/bin/bash

# Read parent pid, child pid
path=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --parent)
      parent="$2"
      shift 2
      ;;
    --child)
      child="$2"
      shift 2
      ;;
    --path)
      path=1
      shift 1
      ;;
    *)
      echo "Unknown parameter passed: $1"
      exit 1
      ;;
  esac
done
# Check if parent or child is empty
if [ -z "$parent" ] || [ -z "$child" ]; then
  echo "Usage: $0 --parent PARENT_PID --child CHILD_PID [--path]"
  exit 1
fi

########
# TODO #
########

## First resolution
# childPPID=$(cat /proc/$child/status | grep PPid | awk '{print $2}')
# childPPPID=$(cat /proc/$childPPID/status | grep PPid | awk '{print $2}')
# # parentPPID=$(cat /proc/$parent/status | grep "PPID" | awk '{print $2}')
# # echo "$childPPID"
# if ["$child" -lt "$parent"]
# then
#   echo "No"
# elif [ "$childPPID" -eq "$parent" ] 
# then
#   echo "Yes"
# elif [ "$childPPPID" -eq "$parent" ]
# then
#   echo "Yes"
# else
#   echo "No"
# fi

## Second resolution
check=0
cnt=1
path_array=()
path_array+=($child)

while [ "$child" -gt "$parent" ]; do
  child=$(cat /proc/$child/status | grep PPid | awk '{print $2}')
  path_array+=($child)
  cnt=$(($cnt + 1))
  if [ "$child" -eq "$parent" ]
  then
    echo "Yes"
    check=1
    ## bonus
    if [ "$path" -eq 1 ]
    then
      for ((i=cnt-1; i>0; i--)); do
        echo -n "${path_array[$i]} -> "
      done
      echo "${path_array[0]}"
    fi
    ## bonus
    exit 1
  fi
done

if [ "$check" -eq 0 ] 
then
  echo "No"
  exit 1
fi

# The code below is only for demonstration purposes, please remove it before submitting.
# echo "parent pid: $parent, child pid: $child"