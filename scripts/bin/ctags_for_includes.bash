#!/bin/bash
usage() {
    echo "Usage:
ctags_for_includes [--list|--errors] [-p|--project-dirs dir1,dir2] [PATH ...]

--list   : Only list headers found by 'gcc -M' and 'find_includes'.
--errors : Only list error from 'gcc -M' and 'find_includes'.
Otherwise create tags all C(++) files in given project directories/current directory
and write to 'tags-external'.

Example:
In catkin_project/src:
ctags_for_includes --project-dirs tools/x,tools/y /opt/ros/noetic/include /usr/include
"
    exit 0
}

# ORIGINAL_ARGS=("$@")
REMAINING_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      usage ;;
    --list) LIST=1; shift ;;
    --errors) ERRORS=1; shift ;;
    -p|--project-dirs)
      PROJECT_DIRS="$2"; REMAINING_ARGS+=("$1" "$2"); shift; shift ;;
    *)
      REMAINING_ARGS+=("$1"); shift ;;
  esac
done

# set -- "${POSITIONAL_ARGS[@]}"
# set -- "${ORIGINAL_ARGS[@]}"

# echo "${POSITIONAL_ARGS[@]}"
echo "${REMAINING_ARGS[@]}"

code_files="$(fd -ec -eh -ecpp -ehpp . ${PROJECT_DIRS//,/ })"
# echo "$code_files"

exit
if [ -z "$code_files" ]; then
    echo '`fd -ec -eh -ecpp -ehpp` did not find any code files!'
fi

if [ "$ERRORS" ]; then
    shift
    gcc -M $code_files 1>/dev/null
    find_includes.bash "${REMAINING_ARGS[@]}" 1>/dev/null

elif [ "$LIST" ]; then
    shift
    # export CPATH="$(fd -td include ../.. | tr '\n' :)"
    gcc -M $code_files 2>/dev/null \
      | tr ' \\' '\n' \
      | grep -v '\.o:[ \t]*$' \
      | grep '\S' \
      | sort -u
    echo '---'
    find_includes.bash "${REMAINING_ARGS[@]}"

else
    gcc -M $code_files 2>/dev/null \
      | tr ' \\' '\n' \
      | grep -v '\.o:[ \t]*$' \
      | grep '\S' \
      | sort -u \
      | grep '^/' \
      | ctags --c++-kinds=+p -o tags-external -L -
    find_includes.bash "${REMAINING_ARGS[@]}" | ctags --c++-kinds=+p -a -o tags-external -L -
fi
