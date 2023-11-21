#!/bin/bash
(cd /workspaces/ ;jupyter lab --ip 0.0.0.0 --port 8888 --allow-root &> /home/admin/jupyter.log) & 
echo "allow 10 sec for JupyterLab to start @ http://$(hostname -I | cut -d' ' -f1):8888 (password 19jan1996)" 
echo "JupterLab logging location:  /home/admin/jupyter.log  (inside the container)" 
cat /home/admin/jupyter.log
echo "export PYTHONPATH=/jetson-voice:/workspaces/microphone/usb_4_mic_array" >> /home/admin/.bashrc
sed 's|torch\.distributed\.is_initialized|torch\.distributed\.is_available\(\) and torch.distributed.is_initialized|' -i /usr/local/lib/python3.8/dist-packages/nemo/collections/asr/modules/conv_asr.py
/bin/bash