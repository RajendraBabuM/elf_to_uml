#!/bin/bash
EXE_PATH=/tmp/uml
std_out=/dev/null

[[ $# -lt 1 ]] && echo "must pass elf filename " && exit 0
mkdir -p $EXE_PATH

OF_ASM_FILE=$EXE_PATH/$1.asm
elf_filename=$1
[[ $# -ge 2 ]] && OF_ASM_FILE=$2 || avr-objdump -D -Mintel,i8086 $elf_filename >  $OF_ASM_FILE

elf_symbol=$EXE_PATH/elf_symbol.txt
functions_addrs=$EXE_PATH/functions_addrs.txt

re='^[0-9]+$'

add_list(){
    local actAddr=$1 
    local function=$2
    local lines=()
    local new_list=()
    echo "address -> function |$actAddr -> $function|"  &>>$std_out

    phyAddr=$(echo "obase=10; $(((16#$actAddr)/2))" | bc) 
    phyAddrPadded=$(printf "%04X" $phyAddr) 
    echo "phyAddrPadded : $phyAddrPadded" &>>$std_out
    var1=${phyAddrPadded:2:4}
    var2=${phyAddrPadded:0:2}
    var1_size=${#var1}
    var2_size=${#var2}
    echo "var1 $var1_size" &>> $std_out
    size=${#var2}
    echo "var2 $var2_size" &>> $std_out
    [[ ( $var1_size -gt 2 )  || ( $var2_size  -gt 2 ) ]] && return

    echo -e "\nvar1 = $var1\nvar2 = $var2" &>>$std_out
    lines=$(grep -n  -A1 -P 'ldi\tr.* 0x'$var1'\t.*'  $OF_ASM_FILE   |  sed -e '/^[0-9]*:/d' | grep -P 'ldi\tr.* 0x'$var2'' | cut -f1 -d '-')

    for line in ${lines[@]} ; do
        echo "line = $line " &>>$std_out
        if ! [[ $line =~ $re ]] ; then
            echo "error: Not a number" &>>$std_out ; #exit 1
        else
            duplicate_flag=1
            [[ ! ${new_list[@]} =~ (^|[[:space:]])$line($|[[:space:]]) ]] && new_list+=($line) && duplicate_flag=0 
            echo "newlisrt ${new_list[@]} -> $duplicate_flag " &>>$std_out
            if [[ $duplicate_flag -eq 0 ]] ; then
                printf "*********** %08d %-50s *********\n" "$line" "${function:0:50}"
                sed -i ''$line's/$/ ; <'$function'>/' $OF_ASM_FILE
            fi
        fi
    done
}

add_list_of_functions () {
    while IFS='' read -r line || [[ -n "$line" ]]; do
        echo " add_list_of_functions : $line "  &>>$std_out
        add_list $line
    done < $1
}

echo "Entering $0 ...,"
objdump -t $elf_filename > $elf_symbol
cat $elf_symbol | grep -sw 'F' | awk '{print $1 " "  $6}' > $functions_addrs
add_list_of_functions $functions_addrs

