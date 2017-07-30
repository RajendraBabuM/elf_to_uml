#!/bin/bash

EXE_PATH=/tmp/uml

[[ $# -lt 1 ]] && echo "must pass .elf file name " && exit 0

mkdir -p $EXE_PATH

IF=$1
ASM_FILE=$EXE_PATH/$1.asm
FUNCTION_LIST=$EXE_PATH/function_list.txt

avr-objdump   -D -Mintel,i8086  $IF > $ASM_FILE
umlcbfunc $IF $ASM_FILE
#objdump   -D -Mintel,i8086  $IF > $ASM_FILE
umlfilelist $IF

create_uml_file () {
    while IFS='' read -r line || [[ -n "$line" ]]; do
        echo "creating uml file for $line ...,"
        umlcrf $ASM_FILE $line
    done < $1
}


create_uml_file  $FUNCTION_LIST
    
