#!/bin/bash 
INSTALATION_PATH=/opt/uml

echo "run in super user mode "
echo "Installation begins ..."

sudo mkdir -p $INSTALATION_PATH 
sudo cp *.sh $INSTALATION_PATH
sudo chmod +x $INSTALATION_PATH/*.sh

echo "creating soft link ..."

sudo ln -sf  /opt/uml/main.sh               /usr/local/bin/umlcr
sudo ln -sf  /opt/uml/create_uml_file.sh    /usr/local/bin/umlcrf
sudo ln -sf  /opt/uml/callback_function.sh  /usr/local/bin/umlcbfunc 
sudo ln -sf  /opt/uml/function_list.sh      /usr/local/bin/umlfilelist
sudo ln -sf  /opt/uml/flow_diagram.sh       /usr/local/bin/umldiag 

echo "Installation Finished!!!"

