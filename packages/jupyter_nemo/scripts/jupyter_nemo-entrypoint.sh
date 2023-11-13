#!/bin/bash
(cd /workspaces/ ;jupyter lab --ip 0.0.0.0 --port 8888 --allow-root &> /home/admin/jupyter.log) & 
echo "allow 10 sec for JupyterLab to start @ http://$(hostname -I | cut -d' ' -f1):8888 (password 19jan1996)" 
echo "JupterLab logging location:  /home/admin/jupyter.log  (inside the container)" 
cat /home/admin/jupyter.log
echo "export PYTHONPATH=/jetson-voice" >> /home/root/.bashrc
/bin/bash