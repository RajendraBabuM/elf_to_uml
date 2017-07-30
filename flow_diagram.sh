#!/bin/bash

EXE_PATH=/tmp/uml
DIAG_PATH=$EXE_PATH/flow_diagram

[[ $# -lt 1 ]] && echo "must pass function name " && exit 0

mkdir -p $EXE_PATH
mkdir -p $DIAG_PATH

FUCTION_NAME=$1
IF=$EXE_PATH/$FUCTION_NAME.uml
OF=$DIAG_PATH/$1_flow_diagram.uml
TMP_LIST=$EXE_PATH/tmp_list.txt

sed  '$ d' $IF > $OF

funtion_list=()

add_list(){
    #echo "add new funtion |$var|"
    var=$1
    #[[ ! ${funtion_list[@]} =~ (^|[[:space:]])$var($|[[:space:]]) ]] && funtion_list+=($var) || echo "yes |==$var|"
    [[ ! ${funtion_list[@]} =~ (^|[[:space:]])$var($|[[:space:]]) ]] && funtion_list+=($var) 
}



add_list_of_functions () {
    while IFS='' read -r line || [[ -n "$line" ]]; do
        add_list $line
    done < $1
}

#add_list b

sed '/^@startuml\|^@enduml\|^'$FUCTION_NAME'/d ' $IF > $TMP_LIST
add_list_of_functions $TMP_LIST

i=0
j=${#funtion_list[@]}
while [ $i -le $j ] 
do
    function=${funtion_list[i]}
    if [ ! -z "$function" -a "$function" != " " ]; then
        IF=$EXE_PATH/$function.uml 
        #echo "search file |$IF|"
        sed '/^@startuml\|^@enduml\|^'$function'/d ' $IF > $TMP_LIST
        add_list_of_functions $TMP_LIST
        cat $TMP_LIST >> $OF
        j=${#funtion_list[@]}
    fi
    ((i++))
done

echo "@enduml" >> $OF
# " remove duplicate lines "
cp $OF $TMP_LIST
awk '!a[$0]++' $TMP_LIST > $OF 
echo "function dependency : ${funtion_list[@]}"
plantuml  $OF &

