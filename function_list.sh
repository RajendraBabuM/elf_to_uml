#!/bin/bash
EXE_PATH=/tmp/uml

[[ $# -lt 1 ]] && echo "must pass .elf file" && exit 0

mkdir -p $EXE_PATH

FNAME=$1 
LIST_ALL_FUNCTIONS=$EXE_PATH/list_all_functions.txt
RM_1_CLM=$EXE_PATH/rm_1_clm.txt
RM_LOCAL_DEFINITIONS=$EXE_PATH/rm_local_definitions.txt
FUNC_LIST=$EXE_PATH/function_list.txt

nm $FNAME > $LIST_ALL_FUNCTIONS 
cut -f2-3 -d ' ' $LIST_ALL_FUNCTIONS > $RM_1_CLM
sed  '/^A\|^a\|^B\|^b\|^D\|^d\|^N\|^W\|^t __c/d' $RM_1_CLM > $RM_LOCAL_DEFINITIONS
cut -f2 -d' ' $RM_LOCAL_DEFINITIONS > $FUNC_LIST
sed -i '/^$/d' $FUNC_LIST

