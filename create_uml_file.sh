#!/bin/bash
EXE_PATH=/tmp/uml

[[ $# -lt 2 ]] && echo "must pass function name" && exit 0

mkdir -p $EXE_PATH

FILE_A=$EXE_PATH/a.asm
FILE_B=$EXE_PATH/b.asm
FILE_C=$EXE_PATH/c.asm
FILE_D=$EXE_PATH/d.asm

MAINAPP=$1
FNAME=$2
UML_OF=/tmp/uml/$FNAME.uml

echo "searching function \" $FNAME \" ..,"

grep -e "$FNAME" -e '^00' $MAINAPP > $FILE_A
awk '/^00/{print ""}1' $FILE_A > $FILE_B
sed -e "/<$FNAME>:/,/^$/d" $FILE_B > $FILE_C
sed -e "/__c./,/^$/d" $FILE_C > $FILE_D

echo "@startuml" > $UML_OF
echo "$FNAME --> [*]" >> $UML_OF
grep -e "$FNAME[>,+]"  -B1 $FILE_D | grep "^00" | awk  -v var="$FNAME" -F'[<>]' '{print $2 " --> " var }' >> $UML_OF
echo "@enduml" >> $UML_OF

sed -i '/^.debug\|^__heap_\|^.do_clear_bss_start\|^__do_clear_bss/d' $UML_OF
#grep  -v '__heap_' $UML_OF > $UML_OF 

echo "created  \" $UML_OF \""

