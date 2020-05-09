#!/bin/bash
sudo docker run --publish 8900:8899 --name cs231pj --runtime=nvidia --rm -it cs231n:project
