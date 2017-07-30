#!/bin/bash 
INSTALATION_PATH=/opt/uml

echo "run in super user mode "
sudo date
echo "Installation begins ..."

mkdir -p $INSTALATION_PATH 
cp *.sh $INSTALATION_PATH
chmod +x $INSTALATION_PATH/*.sh

echo "creating soft link ..."

ln -s  /opt/uml/main.sh               /usr/local/bin/umlcr
ln -s  /opt/uml/create_uml_file.sh    /usr/local/bin/umlcrf
ln -s  /opt/uml/callback_function.sh  /usr/local/bin/umlcbfunc 
ln -s  /opt/uml/function_list.sh      /usr/local/bin/umlfilelist
ln -s  /opt/uml/flow_diagram.sh       /usr/local/bin/umldiag 

echo "Installation Finished!!!"

